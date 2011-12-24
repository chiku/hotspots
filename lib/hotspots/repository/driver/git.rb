module Hotspots
  module Repository
    module Driver
      class Git
        class << self
          def pretty_log(options)
            command = %Q(git log --pretty="%H" --since #{options[:since_days]}.days.ago --grep "#{options[:message_filter]}")
              .tap {|raw| ::Hotspots::Logger.log "<Input> #{raw}"}
            %x(#{command})
              .tap {|raw| ::Hotspots::Logger.log raw}
              .gsub("\r", "")
          end

          def show_one_line_names(options)
            command = %Q(git show --oneline --name-only #{options[:commit_hash]})
              .tap {|raw| ::Hotspots::Logger.log "<Input> #{raw}"}
            %x(#{command})
              .tap {|raw| ::Hotspots::Logger.log "<Output> #{raw}"}
              .gsub("\r", "")
          end
        end
      end
    end
  end
end
