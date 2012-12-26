module Hotspots
  module Repository #:nodoc: all
    module Command
      module Git
        class Log
          attr_reader :since_days, :message_filter

          def initialize(options)
            @since_days     = options[:since_days]
            @message_filter = options[:message_filter].to_s
          end

          def build
            "git log --pretty=\"%H\" #{since_clause}#{grep_clause}"
          end

          def since_clause
            "--since=\"#{since_days} days ago\""
          end

          def grep_clause
            message_filter.empty? ? "" : " --grep \"#{message_filter}\""
          end
        end

        class Show
          attr_reader :commit_hash

          def initialize(options)
            @commit_hash = options[:commit_hash]
          end

          def build
            "git show --oneline --name-only #{commit_hash}"
          end
        end
      end
    end
  end
end
