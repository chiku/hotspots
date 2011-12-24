module Hotspots
  module Repository
    module Driver
      class Git
        def initialize(options)
          @time            = options[:time]
          @message_filters = options[:message_filter]
        end
      end
    end
  end
end
