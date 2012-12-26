module Hotspots
  module OptionBasedExit
    class Error
      attr_reader :code, :message

      def initialize(options)
        @message = options[:message]
        @code    = options[:code]
      end

      def perform
        puts @message
        exit @code
      end
    end

    class Safe
      attr_reader :code, :message

      def initialize(options)
        @message = options[:message]
        @code    = 0
      end

      def perform
        puts @message
        exit @code
      end
    end

    class Noop
      attr_reader :code, :message

      def initialize(options = {})
        @message = ""
        @code    = nil
      end

      def perform
      end
    end
  end
end

# compatibility begin
require 'hotspots/exit_strategy'
# compatibility end