class Hotspots
  module Repository #:nodoc: all
    module Driver
      class Git
        def initialize(options)
          @log    = options[:logger]
          @colour = options[:colour]
        end

        def pretty_log(options)
          execute_with_log Command::Git::Log.new(:since_days => options[:since_days], :message_filter => options[:message_filter])
        end

        def show_one_line_names(options)
          execute_with_log Command::Git::Show.new(:commit_hash => options[:commit_hash])
        end

        private

        def execute_with_log(command)
          command.run.tap do |output|
            @log.message("[input] #{command}", :level => :info, :colour => :green)
            @log.message("[output] #{output}", :level => :info, :colour => :red)
          end
        end
      end
    end
  end
end
