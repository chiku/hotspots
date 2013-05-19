require 'logger'

class Hotspots
  class Logger
    class Default
      LOG_LEVELS = {
        :debug => ::Logger::DEBUG,
        :info  => ::Logger::INFO,
        :warn  => ::Logger::WARN,
        :error => ::Logger::ERROR,
        :fatal => ::Logger::FATAL,
      }
      LOG_LEVELS.default = ::Logger::ERROR

      def self.create
        ::Logger.new(STDOUT).tap do |logger|
          logger.formatter = proc do |severity, datetime, progname, msg|
            "#{datetime}: #{msg}\n"
          end
        end
      end
    end
  end
end
