# compatibility begin
module Hotspots
  module OptionBasedExit
    class Error; end
    class Safe; end
    class Noop; end

    ExitStrategy = Error
    ExitStrategy::Safe = Safe
    ExitStrategy::Null = Noop
  end
end
# compatibility end
