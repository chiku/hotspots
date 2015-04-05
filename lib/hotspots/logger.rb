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

    attr_reader :level

    def initialize(options = {})
      @level      = :error
      @levels_map = options[:log_levels] || Levels
      @logger     = options[:logger]     || default_logger

      sync_log_levels
    end

    def as # TODO : Test only method
      @logger
    end

    def message(message, options)
      @logger.send(options[:level]) { ::ANSI::Code.send(options[:colour], message) }
    end

    def level=(l)
      @level = l
      sync_log_levels
      @level
    end

    private

    def sync_log_levels
      @logger.level = @levels_map[@level]
    end

    def default_logger
      ::Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime}: #{msg}\n" }
      end
    end
  end
end
