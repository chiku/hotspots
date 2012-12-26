module Hotspots
  module Repository #:nodoc: all
    module Driver
      class Git
        attr_reader :logger

        def initialize(logger)
          @logger = logger
        end

        def pretty_log(options)
          grep_clause = options[:message_filter].empty? ? "" : " --grep \"#{options[:message_filter]}\""
          command = %Q(git log --pretty="%H" --since="#{options[:since_days]} days ago" #{grep_clause}).
            tap {|raw| logger.log "<Input>\n#{raw}\n</Input>"}
          %x(#{command}).
            tap {|raw| logger.log "<Output>\n#{raw}\n</Output>"}
        end

        def show_one_line_names(options)
          command = %Q(git show --oneline --name-only #{options[:commit_hash]}).
            tap {|raw| logger.log "<Input>\n#{raw}\n</Input>"}
          %x(#{command}).
            tap {|raw| logger.log "<Output>\n#{raw}\n</Output>"}
        end
      end
    end
  end
end
