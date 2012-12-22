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

    attr_reader :sink
    def initialize
      @sink = Null
    end

    def set_console
      @sink = Console
    end

    def log(message)
      @sink << format(message)
    end

    def format(message)
      "[#{Time.now}] #{message}\n"
    end
  end
end
