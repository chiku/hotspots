require 'hotspots/version'
require 'hotspots/logger'
require 'hotspots/configuration'
require 'hotspots/store'
require 'hotspots/options_parser'
require 'hotspots/repository'

class Hotspots
  class << self
    def configure(&block)
      yield configuration = Configuration.new
      Hotspots.new(:configuration => configuration)
    end
  end

  def initialize(opts)
    @configuration   = opts[:configuration]
    @logger          = @configuration.logger
    @repository      = @configuration.repository
    @exit_strategy   = @configuration.exit_strategy
    @time            = @configuration.time
    @message_filters = @configuration.message_filters
    @file_filter     = @configuration.file_filter
    @cutoff          = @configuration.cutoff
  end

  def output
    validate
    set
    run
  end

  private

  def validate
    exit_if_options_are_for_help
    exit_if_not_git_repository
  end

  def set
    set_path
    assign
  end

  def run
    puts @store.to_s
  end

  def exit_if_options_are_for_help
    @exit_strategy.perform
  end

  def exit_if_not_git_repository
    output = `git status 2>&1`
    unless $? == 0
      puts "'#{@repository}' doesn't seem to be a git repository!"
      exit 10
    end
  end

  def set_path
    Dir.chdir(@repository)
  end

  def assign
    @driver = Hotspots::Repository::Driver::Git.new(:logger => @logger)
    @parser = Hotspots::Repository::Parser::Git.new(@driver, :time => @time, :message_filters => @message_filters)
    @store  = Hotspots::Store.new(@parser.files, :cutoff => @cutoff, :file_filter => @file_filter)
  end
end
