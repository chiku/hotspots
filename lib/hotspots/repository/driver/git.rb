class Hotspots
  module Repository #:nodoc: all
    module Driver
      class Git
        attr_reader :logger, :colour

        def initialize(options)
          @logger = options[:logger]
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
            logger.as.info { colour.as("green", "[input] #{command}") }
            logger.as.info { colour.as("red", "[output] #{output}") }
          end
        end
      end
    end
  end
end
