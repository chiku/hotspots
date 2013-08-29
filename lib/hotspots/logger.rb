require 'hotspots/logger/colour'
require 'hotspots/logger/default'

class Hotspots
  class Logger
    attr_reader :level
    attr_reader :colour

    def initialize(options = {})
      @levels_map     = options[:log_levels]     || Default::LEVELS
      @colour_schemes = options[:colour_schemes] || Colour::Schemes
      @logger         = options[:logger]         || Default.create
      @colour         = options[:colour]         || Colour::Null
      @level          = :error

      sync_log_levels
    end

    def as
      @logger
    end

    def message(message, options)
      @logger.send(options[:level]) { @colour.as(options[:colour], message) }
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
  end
end
