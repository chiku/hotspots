module Hotspots
  module Repository #:nodoc: all
    module Parser
      class Git
        attr_reader :driver, :time, :message_filters

        def initialize(driver, options)
          @driver          = driver
          @time            = options[:time]
          @message_filters = options[:message_filters]
        end

        # TODO : replace with each_line
        def files
          filtered_commit_hashes.map do |commit_hash|
            driver.show_one_line_names(:commit_hash => commit_hash).
              gsub("\r\n", "\n").
              gsub("\r", "\n").
              split("\n")[1..-1]
          end.flatten
        end

        # TODO : replace with each_line
        def filtered_commit_hashes
          message_filters.map do |filter|
            driver.pretty_log(:since_days => time, :message_filter => filter).
              gsub("\r\n", "\n").
              gsub("\r", "\n").
              split("\n")
          end.flatten.uniq
        end
      end
    end
  end
end
