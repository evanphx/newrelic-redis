require 'test/unit'
require 'redis'

require 'newrelic_rpm'
require 'newrelic_redis/instrumentation'

DependencyDetection.detect!

NewRelic::Agent.require_test_helper

class TestNewRelicRedis < Test::Unit::TestCase
  PORT = 6381
  OPTIONS = {:port => PORT, :db => 15, :timeout => 0.1}

  def setup
    NewRelic::Agent.drop_buffered_data

    @redis = Redis.new OPTIONS
    @client = @redis.client
  end

  def assert_metrics(*m)
    assert_metrics_recorded(m)
  end

  def assert_segment_has_key(segment_name, expected)
    sample = NewRelic::Agent.agent.transaction_sampler.tl_builder.sample
    segment = find_segment_with_name(sample, segment_name)
    assert_equal expected, segment.params[:statement]
  end

  def test_call
    with_config(:'transaction_tracer.record_sql' => 'raw') do
      in_transaction do
        @redis.hgetall "foo"
        assert_segment_has_key "Datastore/operation/Redis/select", "[[:select, 15]]"
        assert_segment_has_key "Datastore/operation/Redis/hgetall", "[[:hgetall, \"foo\"]]"
      end
    end

    assert_metrics "Datastore/all",
                   "Datastore/allOther",
                   "Datastore/Redis/all",
                   "Datastore/Redis/allOther",
                   "Datastore/operation/Redis/select",
                   "Datastore/operation/Redis/hgetall"
  end

  def test_call_pipelined
    with_config(:'transaction_tracer.record_sql' => 'raw') do
      in_transaction do
        @redis.pipelined do
          @redis.hgetall "foo"
          @redis.incr "bar"
        end

        assert_segment_has_key "Datastore/operation/Redis/select", "[[:select, 15]]"
        assert_segment_has_key "Datastore/operation/Redis/pipelined", "[[:hgetall, \"foo\"], [:incr, \"bar\"]]"
      end
    end

    assert_metrics "Datastore/all",
                   "Datastore/allOther",
                   "Datastore/Redis/all",
                   "Datastore/Redis/allOther",
                   "Datastore/operation/Redis/select",
                   "Datastore/operation/Redis/pipelined",
                   "Datastore/operation/Redis/hgetall_pipelined",
                   "Datastore/operation/Redis/incr_pipelined"
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
    with_config(:'transaction_tracer.record_sql' => 'obfuscated') do
      in_transaction do
        @redis.pipelined do
          @redis.hgetall "foo"
          @redis.incr "bar"
        end

        assert_segment_has_key "Datastore/operation/Redis/select", "[[:select, \"?\"]]"
        assert_segment_has_key "Datastore/operation/Redis/pipelined", "[[:hgetall, \"?\"], [:incr, \"?\"]]"
      end
    end

    assert_metrics "Datastore/all",
                   "Datastore/allOther",
                   "Datastore/Redis/all",
                   "Datastore/Redis/allOther",
                   "Datastore/operation/Redis/select",
                   "Datastore/operation/Redis/pipelined",
                   "Datastore/operation/Redis/hgetall_pipelined",
                   "Datastore/operation/Redis/incr_pipelined"
  end
end
