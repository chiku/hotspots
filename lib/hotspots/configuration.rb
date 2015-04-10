require "logger"

class Hotspots
  class Configuration #:nodoc: all
    attr_accessor :repository, :time, :message_filters, :file_filter, :cutoff
    attr_accessor :logger
    attr_accessor :exit_strategy

    def initialize(options = {})
      @repository       = "."
      @time             = 15
      @message_filters  = [""]
      @file_filter      = ""
      @cutoff           = 0
      @info_log_level   = options[:info_log_level]  || ::Logger::INFO
      @error_log_level  = options[:error_log_level] || ::Logger::ERROR
      @logger           = options[:logger]          || default_logger
      @exit_strategy    = Exit::Noop.new
      @logger.level     = @error_log_level
    end

    def log_level
      @logger.level
    end

    def enable_verbosity
      @logger.level = @info_log_level
    end

    private

    def default_logger
      ::Logger.new(STDOUT).tap do |logger|
        logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime}: #{msg}\n" }
      end
    end
  end
end
