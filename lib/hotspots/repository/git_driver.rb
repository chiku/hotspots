module Hotspots
  module Repository
    class GitDriver
      def initialize(options)
        @repository      = options[:repository]
        @time            = options[:time]
        @message_filters = options[:message_filter].split("|")
        @message_filters = [""] if @message_filters.empty?
      end

      def files
        validate!
        Dir.chdir(@repository)
        all_affected_files
      end

      def validate!
        if not File.directory?(@repository) and not File.directory?(File.join(@repository, '.git'))
          puts "#{@repository} doesn't seem to be a git repository!"
          exit 2
        end
      end

      def all_affected_files
        result = []

        filtered_commit_hashes.map do |filter, commit_hashes|
          #puts "\n#{filter}"

          result << commit_hashes.map do |commit_hash|
            %x(git show --oneline --name-only #{commit_hash}).gsub("\r", "").split("\n")[1..-1] # .tap {|file| puts file}
          end
        end
        #puts "**" * 50
        result.flatten
      end

      def filtered_commit_hashes
        result = {}

        @message_filters.map do |filter|
          result[filter] = %x(git log --pretty="%H" --since #{@time}.days.ago --grep "#{filter}").gsub("\r", "").split("\n")
        end.flatten

        result
      end
    end
  end
end