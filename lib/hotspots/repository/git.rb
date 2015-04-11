class Hotspots
  module Repository #:nodoc: all
    module Git
      class << self
        def installed?
          `git --help 2>&1`
          $? == 0
        end

        def inside_valid_repository?
          `git status 2>&1`
          $? == 0
        end
      end
    end
  end
end
