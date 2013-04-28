require 'logger'

class Hotspots
  # TODO : Should understand log levels
  class Logger #:nodoc: all
    module Sink
      class Console
        def initialize
          @logger = ::Logger.new(STDOUT)
          @logger.formatter = proc do |severity, datetime, progname, msg|
            "#{datetime}: #{msg}\n"
          end
        end

        def <<(message)
          @logger.info { message }
        end
      end

      class Null
        def initialize
        end

        def <<(message)
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
      @sink = Sink::Null.new
      @colour = Colour::Null
    end

    def as_console
      @sink = Sink::Console.new
    end

    def colourize
      require 'ansi/code'
      @colour = Colour::ANSI
    end

    def info(message, options = {})
      sink << format(message, options)
    end

    private

    def format(message, options = {})
      colour.as(options[:as] || "black", message)
    end
  end
end
