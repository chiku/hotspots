class Hotspots
  module Repository #:nodoc: all
    module Driver
      class Git
        attr_reader :logger

        def initialize(logger)
          @logger = logger
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
            logger.info("[input] #{command}", :as => "green")
            logger.info("[output] #{output}", :as => "red")
          end
        end
      end
    end
  end
end
