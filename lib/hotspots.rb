require 'hotspots/version'
require 'hotspots/logger'
require 'hotspots/store'
require 'hotspots/options_parser'
require 'hotspots/repository'

module Hotspots
  class Main
    attr_reader :logger, :options, :repository, :verbose,
                :exit_strategy, :driver, :parser, :store

    def initialize(opts = nil)
      @options       = opts.nil? ? Hotspots::OptionsParser.new.parse(*ARGV) : Hotspots::OptionsParser.default_options.merge(opts)
      @repository    = options[:repository]
      @verbose       = options[:verbose]
      @exit_strategy = options[:exit_strategy]
      @logger        = Hotspots::Logger.new
    end

    def output
      validate
      set
      run
    end

    # TODO : this methods should be private
    def validate
      exit_if_options_are_for_help
      exit_if_not_git_repository
    end

    # TODO : this methods should be private
    def set
      set_logger_if_verbose
      set_path
      assign
    end

    # TODO : this methods should be private
    def run
      puts store.to_s
    end

    # TODO : these methods should be private
    # compatibility begin
    alias_method :execute!, :output
    alias_method :validate!, :validate
    # compatibility end

    private

    def exit_if_options_are_for_help
      exit_strategy.perform
    end

    def exit_if_not_git_repository
      output = `git status 2>&1`
      unless $? == 0
        puts "'#{repository}' doesn't seem to be a git repository!"
        exit 10
      end
    end

    def set_logger_if_verbose
      if verbose
        logger.as_console
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
