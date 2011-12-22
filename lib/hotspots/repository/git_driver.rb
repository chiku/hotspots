module Hotspots
  module Repository
    class GitDriver
      def initialize(options)
        @repository = options[:repository]
        @time       = options[:time]
      end

      def files
        validate!
        Dir.chdir(@repository)

        commit_hashes = %x(git log --pretty="%H" --since #{@time}.days.ago).gsub("\r", "").split("\n")
        commit_hashes.map do |commit_hash|
          %x(git show --oneline --name-only #{commit_hash}).gsub("\r", "").split("\n")[1..-1]
        end.flatten
      end

      def validate!
        if not File.directory?(@repository) and not File.directory?(File.join(@repository, '.git'))
          puts "#{@repository} doesn't seem to be a git repository!"
          exit 2
        end
      end
    end
  end
end
