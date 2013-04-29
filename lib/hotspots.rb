require 'logger'

require 'hotspots/version'
require 'hotspots/colour'
require 'hotspots/store'
require 'hotspots/options_parser'
require 'hotspots/repository'
require 'hotspots/compatibility'

class Hotspots
  LOG_LEVELS = {
    :debug => ::Logger::DEBUG,
    :info  => ::Logger::INFO,
    :warn  => ::Logger::WARN,
    :error => ::Logger::ERROR,
    :fatal => ::Logger::FATAL,
  }
  LOG_LEVELS.default = ::Logger::ERROR

  attr_reader :logger, :repository, :log_level, :colour,
              :exit_strategy, :driver, :parser, :store,
              :time, :message_filters, :file_filter, :cutoff

  def initialize(opts)
    options          = Hotspots::OptionsParser.default_options.merge(opts)

    @logger          = ::Logger.new(STDOUT)
    @repository      = options[:repository]
    @log_level       = options[:log_level]
    @colour          = Hotspots::Colour.enable(options[:colour])
    @exit_strategy   = options[:exit_strategy]
    @time            = options[:time]
    @message_filters = options[:message_filters]
    @file_filter     = options[:file_filter]
    @cutoff          = options[:cutoff]
  end

  def output
    validate
    set
    run
  end

  private

  def validate #:nodoc:
    exit_if_options_are_for_help
    exit_if_not_git_repository
  end

  def set #:nodoc:
    configure_logger
    set_path
    assign
  end

  def run #:nodoc:
    puts store.to_s
  end

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

  def configure_logger
    logger.level = LOG_LEVELS[log_level]
    logger.formatter = proc do |severity, datetime, progname, msg|
      "#{datetime}: #{msg}\n"
    end
  end

  def set_path
    Dir.chdir(repository)
  end

  def assign
    @driver = Hotspots::Repository::Driver::Git.new :logger => logger, :colour => colour
    @parser = Hotspots::Repository::Parser::Git.new driver, :time => time, :message_filters => message_filters
    @store  = Hotspots::Store.new parser.files, :cutoff => cutoff, :file_filter => file_filter
  end
end
