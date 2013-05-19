require 'hotspots/logger/default'

class Hotspots
  class Logger
    attr_reader :level

    def initialize(options = {})
      @levels_map   = options[:log_levels] || Default::LEVELS
      @logger       = options[:logger]     || Default.create

      @level        = @levels_map[:error]
      @logger.level = @level
    end

    def as
      @logger
    end

    def level=(l)
      @logger.level = @level = l
    end
  end
end
