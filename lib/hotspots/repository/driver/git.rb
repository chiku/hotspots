module Hotspots
  module Repository #:nodoc: all
    module Driver
      class Git
        attr_reader :logger

        def initialize(logger)
          @logger = logger
        end

        # Input and output should be optionally coloured
        def pretty_log(options)
          command = log_with_tag("Input", :as => :green) { Command::Git::Log.new(:since_days => options[:since_days], :message_filter => options[:message_filter]).build }
          log_with_tag("Output", :as => :red) { %x(#{command}) }
        end

        # Input and output should be optionally coloured
        def show_one_line_names(options)
          command = log_with_tag("Input", :as => :green) { Command::Git::Show.new(:commit_hash => options[:commit_hash]).build }
          log_with_tag("Output", :as => :red) { %x(#{command}) }
        end

        def log_with_tag(tag, options, &block)
          yield.tap { |raw| logger.log("<#{tag}>\n#{raw}<#{tag}/>", :as => options[:as]) }
        end
      end
    end
  end
end
