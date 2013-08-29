require 'logger'

class Hotspots
  class Logger
    class Default #:nodoc: all
      LEVELS = {
        :debug => ::Logger::DEBUG,
        :info  => ::Logger::INFO,
        :warn  => ::Logger::WARN,
        :error => ::Logger::ERROR,
        :fatal => ::Logger::FATAL,
      }
      LEVELS.default = ::Logger::ERROR

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
