require 'hotspots/logger/default'
require 'hotspots/logger/colour'

class Hotspots
  class Logger
    attr_reader :level
    attr_reader :colour

    def initialize(options = {})
      @levels_map   = options[:log_levels] || Default::LEVELS
      @logger       = options[:logger]     || Default.create
      @colour       = options[:colour]     || Colour::Null
      @level        = :error

      sync_log_levels
    end

    def as
      @logger
    end

    def message(options)
      @logger.send(options[:level]) { @colour.as(options[:colour], options[:message]) }
    end

    def level=(l)
      @level = l
      sync_log_levels
      @level # TODO test this
    end

    def colour=(c)
      @colour = c
      sync_colours
      @colour # TODO test this
    end

    private

    def sync_log_levels
      @logger.level = @levels_map[@level]
    end

    def sync_colours
      @colour = Colour.enable(@colour)
    end
  end
end
