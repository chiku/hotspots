module Hotspots
  class Logger #:nodoc: all
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

    def log(message, options = {})
      @sink << format(message)
    end

    def format(message)
      "[#{Time.now}] #{message}\n"
    end

    # compatibility begin
    alias_method :set_console, :as_console
    # compatibility end
  end
end
