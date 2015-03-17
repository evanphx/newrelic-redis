require 'new_relic/agent/method_tracer'

# Redis instrumentation.
#  Originally contributed by Ashley Martens of ngmoco
#  Rewritten, reorganized, and repackaged by Evan Phoenix

DependencyDetection.defer do
  @name = :redis

  depends_on do
    defined?(::Redis) &&
      !NewRelic::Control.instance['disable_redis'] &&
      ENV['NEWRELIC_ENABLE'].to_s !~ /false|off|no/i
  end

  executes do
    NewRelic::Agent.logger.info 'Installing Redis Instrumentation'
  end

  executes do
    require 'new_relic/agent/datastores'

    ::Redis::Client.class_eval do
      # Support older versions of Redis::Client that used the method
      # +raw_call_command+.

      call_method = ::Redis::Client.new.respond_to?(:call) ? :call : :raw_call_command

      def call_with_newrelic_trace(*args, &blk)
        method_name = args[0].is_a?(Array) ? args[0][0] : args[0]
        callback = proc do |result, metric, elapsed|
          _send_to_new_relic(args, elapsed)
        end

        NewRelic::Agent::Datastores.wrap("Redis", method_name, nil, callback) do
          call_without_newrelic_trace(*args, &blk)
        end
      end

      alias_method :call_without_newrelic_trace, call_method
      alias_method call_method, :call_with_newrelic_trace

      # Older versions of Redis handle pipelining completely differently.
      # Don't bother supporting them for now.
      #
      if public_method_defined? :call_pipelined
        def call_pipelined_with_newrelic_trace(commands, *rest)
          # Report each command as a metric suffixed with _pipelined, so the
          # user can at least see what all the commands were.
          additional = commands.map do |c|
            name = c.kind_of?(Array) ? c[0] : c
            "Datastore/operation/Redis/#{name.to_s.downcase}_pipelined"
          end

          callback = proc do |result, metric, elapsed|
            _send_to_new_relic(commands, elapsed)
            additional.each do |additional_metric|
              NewRelic::Agent::MethodTracer.trace_execution_scoped(additional_metric) do
                # No-op, just getting them as placeholders in the trace tree
              end
            end
          end

          NewRelic::Agent::Datastores.wrap("Redis", "pipelined", nil, callback) do
            call_pipelined_without_newrelic_trace commands, *rest
          end
        end

        alias_method :call_pipelined_without_newrelic_trace, :call_pipelined
        alias_method :call_pipelined, :call_pipelined_with_newrelic_trace
      end

      def _send_to_new_relic(args, elapsed)
        if NewRelic::Control.instance["transaction_tracer.record_sql"] == "obfuscated"
          args.map! { |arg| [arg.first] + ["?"] * (arg.count - 1) }
        end
        NewRelic::Agent::Datastores.notice_statement(args.inspect, elapsed)
      end
    end
  end
end


