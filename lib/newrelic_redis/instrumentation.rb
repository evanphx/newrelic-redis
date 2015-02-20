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
    ::Redis::Client.class_eval do
      # Support older versions of Redis::Client that used the method
      # +raw_call_command+.

      call_method = ::Redis::Client.new.respond_to?(:call) ? :call : :raw_call_command

      def call_with_newrelic_trace(*args, &blk)
        if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
          total_metric = 'Datastore/Redis/allWeb'
        else
          total_metric = 'Datastore/Redis/allOther'
        end

        method_name = args[0].is_a?(Array) ? args[0][0] : args[0]
        metrics = ["Datastore/Redis/#{method_name.to_s.upcase}", total_metric]

        self.class.trace_execution_scoped(metrics) do
          start = Time.now

          begin
            call_without_newrelic_trace(*args, &blk)
          ensure
            _send_to_new_relic(args, start)
          end
        end
      end

      alias_method :call_without_newrelic_trace, call_method
      alias_method call_method, :call_with_newrelic_trace

      # Older versions of Redis handle pipelining completely differently.
      # Don't bother supporting them for now.
      #
      if public_method_defined? :call_pipelined
        def call_pipelined_with_newrelic_trace(commands, *rest)
          if NewRelic::Agent::Instrumentation::MetricFrame.recording_web_transaction?
            total_metric = 'Datastore/Redis/allWeb'
          else
            total_metric = 'Datastore/Redis/allOther'
          end

          # Report each command as a metric under pipelined, so the user
          # can at least see what all the commands were. This prevents
          # metric namespace explosion.

          metrics = ["Datastore/Redis/Pipelined", total_metric]

          commands.each do |c|
            name = c.kind_of?(Array) ? c[0] : c
            metrics << "Datastore/Redis/Pipelined/#{name.to_s.upcase}"
          end

          self.class.trace_execution_scoped(metrics) do
            start = Time.now

            begin
              call_pipelined_without_newrelic_trace commands, *rest
            ensure
              _send_to_new_relic(commands, start)
            end
          end
        end

        alias_method :call_pipelined_without_newrelic_trace, :call_pipelined
        alias_method :call_pipelined, :call_pipelined_with_newrelic_trace
      end

      def _send_to_new_relic(args, start)
        if NewRelic::Control.instance["transaction_tracer.record_sql"] == "obfuscated"
          args.map! { |arg| [arg.first] + ["?"] * (arg.count - 1) }
        end
        s = NewRelic::Agent.instance.transaction_sampler
        s.notice_nosql(args.inspect, (Time.now - start).to_f) rescue nil
      end
    end
  end
end


