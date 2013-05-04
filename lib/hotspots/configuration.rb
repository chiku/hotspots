# TODO : Don't depend on OpenStruct
require 'ostruct'

class Hotspots
  class Configuration #:nodoc: all
    attr_accessor :repository, :time, :message_filters, :file_filter, :cutoff
    attr_accessor :colour, :logger
    attr_accessor :exit_strategy

    attr_reader   :log_level

    def initialize
      @repository       = "."
      @time             = 15
      @message_filters  = [""]
      @file_filter      = ""
      @cutoff           = 0

      @colour           = false
      @logger           = OpenStruct.new # TODO Make it an all absorbing object

      @log_level        = :error
      @exit_strategy    = Exit::Noop.new
    end

    def log_level=(l)
      # TODO : may not need to set log level outside of logger
      @log_level = @logger.level = l
    end
  end
end
