require 'forwardable'
require 'logger'

class Hotspots
  class Logger #:nodoc: all
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

    attr_reader :colour, :logger

    LEVELS = {
      :debug => ::Logger::DEBUG,
      :info  => ::Logger::INFO,
      :warn  => ::Logger::WARN,
      :error => ::Logger::ERROR,
      :fatal => ::Logger::FATAL,
    }
    LEVELS.default = ::Logger::ERROR

    def initialize
      @colour = Colour::Null
      @logger = ::Logger.new(STDOUT)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime}: #{msg}\n"
      end
    end

    def level=(l)
      @logger.level = LEVELS[l]
    end

    def colourize
      require 'ansi/code'
      @colour = Colour::ANSI
    end

    LEVELS.keys.each do |method_name|
      define_method(method_name) do |message, options|
        options ||= {}
        logger.send(method_name, format(message, options))
      end
    end

    private

    def format(message, options = {})
      colour.as(options[:colour], message)
    end
  end
end
