require "hotspots/version"
require "hotspots/exit"
require "hotspots/configuration"
require "hotspots/store"
require "hotspots/options_parser"
require "hotspots/repository"

class Hotspots
  def initialize(configuration)
    @configuration   = configuration
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
    assign
    inside_repository do
      run
    end
  end

  private

  def validate
    @exit_strategy.perform
    prepare_for_exit_if_git_status_invalid
    @exit_strategy.perform
  end

  def assign
    @driver = Hotspots::Repository::GitDriver.new(:logger => @logger)
    @parser = Hotspots::Repository::GitParser.new(@driver, :time => @time, :message_filters => @message_filters)
    @store  = Hotspots::Store.new(@parser.files, :cutoff => @cutoff, :file_filter => @file_filter)
  end

  def inside_repository
    yield Dir.chdir(@repository)
  end

  def run
    puts @store.to_s
  end

  def prepare_for_exit_if_git_status_invalid
    `git status 2>&1`
    unless $? == 0
      @exit_strategy = Hotspots::Exit::Error.new(:message => "'#{@repository}' doesn't seem to be a git repository!", :code => 10)
    end
  end
end
