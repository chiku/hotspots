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

    def as_console
      @sink = Console
    end

    # compatibility begin
    alias_method :set_console, :as_console
    # compatibility end

    def log(message)
      @sink << format(message)
    end

    def format(message)
      "[#{Time.now}] #{message}\n"
    end
  end
end
