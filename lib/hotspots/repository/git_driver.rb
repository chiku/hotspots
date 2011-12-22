module Hotspots
  module Repository
    class GitDriver
      def self.files(options)
        files = %x(
          bash -c '\
            cd #{options[:repository]} && \
            git log --pretty="%H" --since #{options[:time]}.days.ago |
            while read commit_hash
              do
              git show --oneline --name-only $commit_hash | tail -n+2
            done
          '
        ).split("\n")
      end
    end
  end
end
