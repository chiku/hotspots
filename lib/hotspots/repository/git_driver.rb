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
        @logger.info { ::ANSI::Code.blue("[input]\n#{command}") }
        output = %x(#{command.to_s})
        @logger.info { ::ANSI::Code.green("[output]\n#{output}") }
        output
      end
    end
  end
end
