module Hotspots
  class Logger
    class Console
      def self.<<(message)
        $stdout << message
      end
    end

    class Null
      def self.<<(message)
      end
    end

    attr_reader :drain
    def initialize
      @drain = Null
    end

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