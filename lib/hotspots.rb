require 'hotspots/version'
require 'hotspots/logger'
require 'hotspots/store'
require 'hotspots/options_parser'
require 'hotspots/repository'

module Hotspots
  class Main
    attr_reader :logger, :options, :repository, :verbose,
                :exit_strategy, :driver, :parser, :store

    def initialize
      @options       = Hotspots::OptionsParser.new.parse(*ARGV)
      @repository    = options[:repository]
      @verbose       = options[:verbose]
      @exit_strategy = options[:exit_strategy]
      @logger        = Hotspots::Logger.new
    end

    def execute!
      validate!
      set
      run
    end

    def validate!
      validate_early_exit!
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

    def validate_early_exit!
      exit_strategy.perform
    end

    def validate_git_repository!
      if not File.directory?(repository) or not File.directory?(File.join(repository, '.git'))
        puts "'#{repository}' doesn't seem to be a git repository!"
        exit 10
      end
    end

    def set_logger
      if verbose
        logger.set_console
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
