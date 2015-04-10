require "ansi/code"

class Hotspots
  module Repository #:nodoc: all
    class GitDriver
      def initialize(options)
        @logger = options[:logger]
      end

      def pretty_log(options)
        execute GitCommand::Log.new(:since_days => options[:since_days], :message_filter => options[:message_filter])
      end

      def show_one_line_names(options)
        execute GitCommand::Show.new(:commit_hash => options[:commit_hash])
      end

      private

      def execute(command)
        command.run.tap do |output|
          @logger.info { ::ANSI::Code.green("[input]\n#{command}") }
          @logger.info { ::ANSI::Code.red("[output]\n#{output}") }
        end
      end
    end
  end
end
