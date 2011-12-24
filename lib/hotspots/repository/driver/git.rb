module Hotspots
  module Repository
    module Driver
      class Git
        class << self
          def pretty_log(options)
            %x(git log --pretty="%H" --since #{options[:since_days]}.days.ago --grep "#{options[:message_filter]}")
          end
        end
      end
    end
  end
end
