class Hotspots
  class Configuration #:nodoc: all
    attr_accessor :repository, :time, :message_filters, :file_filter, :cutoff
    attr_accessor :logger
    attr_accessor :exit_strategy

    def initialize(opts = {})
      @repository       = "."
      @time             = 15
      @message_filters  = [""]
      @file_filter      = ""
      @cutoff           = 0

      @logger           = opts[:logger] || Hotspots::Logger.new(:colour => false)
      @exit_strategy    = Exit::Noop.new
    end

    def log_level=(l)
      @logger.level = l
    end

    def log_level
      @logger.level
    end

    def colour=(c)
      @logger.colour = c
    end

    def colour
      @logger.colour
    end
  end
end
