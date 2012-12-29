class Hotspots
  # Should understand log levels
  class Logger #:nodoc: all
    module Sink
      class Console
        def self.<<(message)
          $stdout << message
        end
      end

      class Null
        def self.<<(message)
        end
      end
    end

    module Colour
      class ANSI
        def self.as(colour, message)
          ::ANSI::Code.send(colour, message)
        end
      end

      class Null
        def self.as(colour, message)
          message
        end
      end
    end

    attr_reader :sink, :colour

    def initialize
      @sink = Sink::Null
      @colour = Colour::Null
    end

    def as_console
      @sink = Sink::Console
    end

    def colourize
      require 'ansi/code'
      @colour = Colour::ANSI
    end

    def log(message, options = {})
      sink << format(message, options)
    end

    private

    # Time stampimg should be part of log level
    def format(message, options = {})
      colour.as(options[:as] || "black", "[#{Time.now}] #{message}\n")
    end
  end
end
