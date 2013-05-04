# Provides compatibility with older API
# These compatibility layers will be removed in the next major release (v2.0)

Hotspots::Main = Hotspots
class Hotspots
  class Configuration #:nodoc: all
    def [](method_name)
      self.send(method_name)
    end
  end

  class OptionsParser #:nodoc: all
    class << self
      def default_options
        { }
      end
    end
  end
end
