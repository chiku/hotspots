require 'forwardable'
require 'logger'

class Hotspots
  class Logger #:nodoc: all
    class Console
      extend Forwardable

      def initialize
        @logger = ::Logger.new(STDOUT)
        @logger.formatter = proc do |severity, datetime, progname, msg|
          "#{datetime}: #{msg}\n"
        end
      end

      def_delegators :@logger, :level=, :debug, :info, :warn, :error, :fatal
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
      @sink   = Console.new
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
      @sink.level = levels[l]
    end

    def colourize
      require 'ansi/code'
      @colour = Colour::ANSI
    end

    def info(message, options = {})
      sink.info(format(message, options))
    end

    def fatal(message, options = {})
      sink.fatal(format(message, options))
    end

    private

    def format(message, options = {})
      colour.as(options[:colour], message)
    end
  end
end
