require "logger"
require "ansi/code"

class Hotspots
  class Logger #:nodoc: all
    Levels = {
      :debug => ::Logger::DEBUG,
      :info  => ::Logger::INFO,
      :warn  => ::Logger::WARN,
      :error => ::Logger::ERROR,
      :fatal => ::Logger::FATAL,
    }
    Levels.default = ::Logger::ERROR

    ColourPresent = lambda { |colour, message| ::ANSI::Code.send(colour, message) }
    ColourAbsent  = lambda { |colour, message| message }
    ColourSchemes = { true  => ColourPresent, false => ColourAbsent }

    attr_reader :level
    attr_reader :colour

    def initialize(options = {})
      @levels_map     = options[:log_levels]     || Levels # TODO : make non-configurable
      @level          = :error
      @colour_schemes = options[:colour_schemes] || ColourSchemes
      @colour         = options[:colour]         || @colour_schemes[false]
      @logger         = options[:logger]         || default_logger

      sync_log_levels
    end

    def as
      @logger
    end

    def message(message, options)
      @logger.send(options[:level]) { @colour.call(options[:colour], message) }
    end

    def level=(l)
      @level = l
      sync_log_levels
      @level
    end

    def colour=(c)
      @c = c
      sync_colours
      @c
    end

    private

    def sync_log_levels
      @logger.level = @levels_map[@level]
    end

    def sync_colours
      @colour = @colour_schemes[@c]
    end

    def default_logger
      ::Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime}: #{msg}\n" }
      end
    end
  end
end
