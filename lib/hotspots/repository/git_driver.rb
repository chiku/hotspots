class Hotspots
  module Repository #:nodoc: all
    class GitDriver
      def initialize(options)
        @log = options[:logger]
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
          @log.message("[input]\n#{command}", :level => :info, :colour => :green)
          @log.message("[output]\n#{output}", :level => :info, :colour => :red)
        end
      end
    end
  end
end
