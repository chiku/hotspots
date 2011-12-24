module Hotspots
  class Logger
    class Console
      class << self
        def <<(message)
          $stdout << message
        end
      end
    end

    class Null
      class << self
        def <<(message)
        end
      end
    end

    @drain = Null

    class << self
      def set(logger)
        @drain = logger
      end

      def log(message)
        @drain << format(message)
      end

      def format(message)
        "\n<#{Time.now}> #{message}"
      end
    end
  end
end