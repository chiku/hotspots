require 'hotspots/logger/default'

class Hotspots
  class Logger
    attr_reader :level

    def initialize(options = {})
      @levels_map   = options[:log_levels] || Default::LEVELS
      @logger       = options[:logger]     || Default.create
      @level        = :error

      sync_log_levels
    end

    def as
      @logger
    end

    def level=(l)
      @level = l
      sync_log_levels
      @level # test this
    end

    private

    def sync_log_levels
      @logger.level = @levels_map[@level]
    end
  end
end
