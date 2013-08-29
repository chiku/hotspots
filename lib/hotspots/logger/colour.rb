require 'ansi/code'

class Hotspots
  class Logger
    class Colour #:nodoc: all
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

      Schemes = {
        true  => ANSI,
        false => Null,
      }

      def self.enable(enabled)
        Schemes[enabled]
      end
    end
  end
end
