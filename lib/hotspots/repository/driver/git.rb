module Hotspots
  module Repository
    module Driver
      class Git
        class << self
          def pretty_log(options)
            %x(git log --pretty="%H" --since #{options[:since_days]}.days.ago --grep "#{options[:message_filter]}").gsub("\r", "")
          end

          def show_one_line_names(options)
            %x(git show --oneline --name-only #{options[:commit_hash]}).gsub("\r", "")
          end
        end
      end
    end
  end
end
