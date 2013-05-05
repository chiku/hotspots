class Hotspots
  class Configuration #:nodoc: all
    class AbsorbAll
      def method_missing(*args, &block)
        nil
      end
    end

    attr_accessor :repository, :time, :message_filters, :file_filter, :cutoff
    attr_accessor :colour, :logger
    attr_accessor :exit_strategy

    attr_reader   :log_level

    def initialize(opts)
      @log_levels = opts[:log_levels]
      set_deafults
    end

    def log_level=(l)
      @log_level = @logger.level = @log_levels[l]
      @log_level
    end

    def logger=(l)
      @logger = l
      @logger.level = @log_levels[@log_level]
      @logger
    end

    private

    def set_deafults
      @repository       = "."
      @time             = 15
      @message_filters  = [""]
      @file_filter      = ""
      @cutoff           = 0

      @colour           = false
      @logger           = AbsorbAll.new

      @log_level        = :error
      @exit_strategy    = Exit::Noop.new

      @logger.level     = @log_levels[:error]
    end
  end
end
