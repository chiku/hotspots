class Hotspots
  module Repository #:nodoc: all
    module Parser
      class Git
        attr_reader :driver, :time, :message_filters

        def initialize(driver, options)
          @driver          = driver
          @time            = options[:time]
          @message_filters = options[:message_filters]
        end

        def files
          filtered_commit_hashes.reduce([]) do |acc, commit_hash|
            acc + driver.show_one_line_names(:commit_hash => commit_hash).lines.map(&:strip)[1..-1]
          end
        end

        def filtered_commit_hashes
          message_filters.reduce([]) do |acc, filter|
            acc + driver.pretty_log(:since_days => time, :message_filter => filter).lines.map(&:strip)
          end.uniq
        end
      end
    end
  end
end
