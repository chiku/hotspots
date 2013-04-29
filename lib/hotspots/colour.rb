class Hotspots
  class Colour  #:nodoc: all
    class ANSI
      def self.as(colour, message)
        ::ANSI::Code.send(colour, message)
      end
    end

    class Null
      def self.as(colour, message)
        message
      end
    end

    def self.enable(enabled)
      if enabled
        require 'ansi/code'
        ANSI
      else
        Null
      end
    end
  end
end
