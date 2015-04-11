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
    ensure_git_installed
    ensure_git_repository
  end

  def inside_repository
    yield Dir.chdir(repository)
  end

  def run
    puts store.to_s
  end

  def ensure_git_installed
    Exit::Error.new(:message => "git not installed or not present in PATH!", :code => 10).perform unless Repository::Git.installed?
  end

  def ensure_git_repository
    Exit::Error.new(:message => "'#{@repository}' doesn't seem to be a git repository!", :code => 10).perform unless Repository::Git.inside_valid_repository?
  end

  def repository
    configuration.repository
  end

  def store
    Store.new(parser.files, :cutoff => configuration.cutoff, :file_filter => configuration.file_filter)
  end

  def parser
    Repository::GitParser.new(driver, :time => configuration.time, :message_filters => configuration.message_filters)
  end

  def driver
    Repository::GitDriver.new(:logger => configuration.logger)
  end
end
