require File.join(File.expand_path(File.dirname(__FILE__)), 'hotspots', 'version')
require File.join(File.expand_path(File.dirname(__FILE__)), 'hotspots', 'logger')
require File.join(File.expand_path(File.dirname(__FILE__)), 'hotspots', 'store')
require File.join(File.expand_path(File.dirname(__FILE__)), 'hotspots', 'options_parser')
require File.join(File.expand_path(File.dirname(__FILE__)), 'hotspots', 'repository')

module Repository
  class Main
    attr_reader :logger, :options, :repository, :verbose,
                :exit_code, :exit_message,
                :driver, :parser, :store

    def initialize
      @logger       = Hotspots::Logger.new
      @options      = Hotspots::OptionsParser.new.parse(*ARGV)
      @repository   = options[:repository]
      @verbose      = options[:verbose]
      @exit_code    = options[:exit][:code]
      @exit_message = options[:exit][:message]
    end

    def execute!
      validate!
      set
      run
    end

    def validate!
      validate_exit_code!
      validate_git_repository!
    end

    def set
      set_logger
      set_path
      assign
    end

    def run
      puts store.to_s
    end

    private

    def validate_exit_code!
      if exit_code
        puts exit_message
        exit exit_code
      end
    end

    def validate_git_repository!
      if not File.directory?(repository) and not File.directory?(File.join(repository, '.git'))
        puts "'#{repository}' doesn't seem to be a git repository!"
        exit 10
      end
    end

    def set_logger
      if verbose
        logger.set Hotspots::Logger::Console
      end
    end

    def set_path
      Dir.chdir(repository)
    end

    def assign
      @driver = Hotspots::Repository::Driver::Git.new logger
      @parser = Hotspots::Repository::Parser::Git.new driver, options.clone
      @store  = Hotspots::Store.new parser.files, options.clone
    end
  end
end
