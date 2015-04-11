require "ansi/code"
require "open3"

class Hotspots
  module Repository #:nodoc: all
    class GitDriver
      def initialize(options)
        @logger = options[:logger]
      end

      def pretty_log(options)
        execute GitCommand::Log.new(:since_days => options[:since_days], :message_filter => options[:message_filter]).to_s
      end

      def show_one_line_names(options)
        execute GitCommand::Show.new(:commit_hash => options[:commit_hash]).to_s
      end

      private

      def execute(command)
        @logger.info { ::ANSI::Code.blue("[input]\n#{command}") }
        output = ""
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          error = stderr.gets(nil)
          output = stdout.gets(nil)
          @logger.error { ::ANSI::Code.red("[error]\n#{error}") } if error
          @logger.info { ::ANSI::Code.green("[output]\n#{output}") } if output
          Exit::Error.new(:message => "Error encountered while running git", :code => 1).perform unless wait_thr.value.success?
        end
        output
      end
    end
  end
end
