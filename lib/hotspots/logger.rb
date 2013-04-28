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

        def info(message)
          @logger.info { message }
        end

        def level=(l)
          @logger.level = l
        end
      end

      class Null
        def initialize
        end

        def info(message)
        end

        def level=(l)
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
      @sink = Sink::Console.new
      @colour = Colour::Null
    end

    def level=(l)
      levels = {
        :debug => ::Logger::DEBUG,
        :info  => ::Logger::INFO,
        :warn  => ::Logger::WARN,
        :error => ::Logger::ERROR,
        :fatal => ::Logger::FATAL,
      }
      @sink.level = levels[l.to_sym]
    end

    def as_console
      @sink = Sink::Console.new
      @sink.level = ::Logger::DEBUG
    end

    def colourize
      require 'ansi/code'
      @colour = Colour::ANSI
    end

    def info(message, options = {})
      sink.info(format(message, options))
    end

    private

    def format(message, options = {})
      colour.as(options[:as], message)
    end
  end
end
