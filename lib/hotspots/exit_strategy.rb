# compatibility begin
module Hotspots
  module OptionBasedExit #:nodoc: all
    class Error; end
    class Safe; end
    class Noop; end

    ExitStrategy = Error
    ExitStrategy::Safe = Safe
    ExitStrategy::Null = Noop
  end
end
# compatibility end
