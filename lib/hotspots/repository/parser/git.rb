module Hotspots
  module Repository
    module Parser
      class Git
        def initialize(driver, options)
          @driver          = driver
          @time            = options[:time]
          @message_filters = options[:message_filters]
        end

        def files
          filtered_commit_hashes.map do |commit_hash|
            @driver.show_one_line_names(:commit_hash => commit_hash).split("\n")[1..-1]
          end.flatten
        end

        def filtered_commit_hashes
          @message_filters.map do |filter|
            @driver.pretty_log(:since_days => @time, :message_filter => filter).split("\n")
          end.flatten.uniq
        end
      end
    end
  end
end
