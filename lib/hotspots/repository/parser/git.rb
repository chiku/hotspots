module Hotspots
  module Repository
    module Parser
      class Git
        def initialize(driver, options)
          @driver          = driver
          @time            = options[:time]
          @message_filters = options[:message_filter]
        end

        def files
          all_affected_files
        end

        def all_affected_files
          result = []

          filtered_commit_hashes.map do |filter, commit_hashes|
            result << commit_hashes.map do |commit_hash|
              %x(git show --oneline --name-only #{commit_hash}).gsub("\r", "").split("\n")[1..-1]
            end
          end

          result.flatten
        end

        def filtered_commit_hashes
          result = {}

          @message_filters.map do |filter|
            result[filter] = @driver.pretty_log(:since_days => @time, :message_filter => filter).gsub("\r", "").split("\n")
          end.flatten

          result
        end
      end
    end
  end
end
