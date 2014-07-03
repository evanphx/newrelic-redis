require 'test/unit'
require 'redis'

require 'newrelic_redis/instrumentation'

class TestNewRelicRedis < Test::Unit::TestCase
  include NewRelic::Agent::Instrumentation::ControllerInstrumentation

  PORT = 6381
  OPTIONS = {:port => PORT, :db => 15, :timeout => 0.1}

  def setup
    NewRelic::Agent.manual_start
    @engine = NewRelic::Agent.instance.stats_engine
    @engine.clear_stats

    @sampler = NewRelic::Agent.instance.transaction_sampler
    @sampler.enable
    @sampler.reset!
    @sampler.start_builder

    @redis = Redis.new OPTIONS
    @client = @redis.client

    DependencyDetection.detect!
  end

  def teardown
    @sampler.clear_builder
  end

  def assert_metrics(*m)
    m.each do |x|
      assert @engine.metrics.include?(x), "#{x} not in metrics"
    end
  end

  def test_call
    @redis.hgetall "foo"
    assert_metrics "Database/Redis/HGETALL", "Database/Redis/allOther"

    prm = @sampler.builder.current_segment.params
    assert_equal "[[:select, 15]];\n[[:hgetall, \"foo\"]]", prm[:key]
  end

  def test_call_pipelined
    @redis.pipelined do
      @redis.hgetall "foo"
      @redis.incr "bar"
    end

    assert_metrics "Database/Redis/Pipelined",
                   "Database/Redis/Pipelined/HGETALL",
                   "Database/Redis/Pipelined/INCR",
                   "Database/Redis/allOther"

    prm = @sampler.builder.current_segment.params
    assert_equal "[[:select, 15]];\n[[:hgetall, \"foo\"], [:incr, \"bar\"]]", prm[:key]
  end

  def test_call_with_block
    rep = nil

    @redis.client.call [:info] do |reply|
      rep = reply
    end

    if Redis::VERSION.split(".").first.to_i >= 3
      assert_kind_of String, rep
    else
      assert_nil rep
    end
  end

  def test_obfuscated
    NewRelic::Control.instance["transaction_tracer.record_sql"] = "obfuscated"
    @redis.pipelined do
      @redis.hgetall "foo"
      @redis.incr "bar"
    end

    assert_metrics "Database/Redis/Pipelined",
                   "Database/Redis/Pipelined/HGETALL",
                   "Database/Redis/Pipelined/INCR",
                   "Database/Redis/allOther"

    prm = @sampler.builder.current_segment.params
    assert_equal "[[:select, \"?\"]];\n[[:hgetall, \"?\"], [:incr, \"?\"]]", prm[:key]
  end
end
