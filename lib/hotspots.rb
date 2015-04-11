require "hotspots/version"
require "hotspots/exit"
require "hotspots/configuration"
require "hotspots/store"
require "hotspots/options_parser"
require "hotspots/repository"

class Hotspots
  attr_reader :configuration

  def initialize(configuration)
    @configuration = configuration
  end

  def output
    validate
    inside_repository do
      run
    end
  end

  private

  def validate
    configuration.exit_strategy.perform
    ensure_git_repository
  end

  def inside_repository
    yield Dir.chdir(repository)
  end

  def run
    puts store.to_s
  end

  def ensure_git_repository
    `git status 2>&1`
    unless $? == 0
      Hotspots::Exit::Error.new(:message => "'#{@repository}' doesn't seem to be a git repository!", :code => 10).perform
    end
  end

  def repository
    configuration.repository
  end

  def store
    Hotspots::Store.new(parser.files, :cutoff => configuration.cutoff, :file_filter => configuration.file_filter)
  end

  def parser
    Hotspots::Repository::GitParser.new(driver, :time => configuration.time, :message_filters => configuration.message_filters)
  end

  def driver
    Hotspots::Repository::GitDriver.new(:logger => configuration.logger)
  end
end
