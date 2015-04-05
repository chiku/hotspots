require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'minitest_helper')

class Hotspots
  class StubLogger
    attr_accessor :level
  end

  describe "Logger" do
    let(:log_levels) {
      {
        :debug  => :debug_level,
        :info   => :info_level,
        :error  => :error_level,
      }
    }
    let(:colour_schemes) {
      {
        true  => :colourful,
        false => :dull,
      }
    }
    let(:stub_logger) { StubLogger.new }
    let(:logger) {
      Logger.new(:log_levels => log_levels,
                 :colour_schemes => colour_schemes,
                 :logger => stub_logger)
    }

    describe "#initialize" do
      it "sets log level to error" do
        logger.level.must_equal :error
      end

      it "sets log level of the actual logger to error" do
        logger.as.level.must_equal log_levels[:error]
      end
    end

    describe "#as" do
      describe "when not set" do
        let(:logger) { Logger.new(:log_levels => log_levels) }

        it "has a default value" do
          logger.as.wont_equal nil
        end
      end

      describe "when set" do
        it "overrides the default logger" do
          logger.as.must_equal stub_logger
        end
      end
    end

    describe "#level=" do
      it "sets the log level on the logger" do
        logger.level = :debug
        logger.level.must_equal :debug
      end

      it "sets the log level on the actual logger" do
        logger.level = :debug
        logger.as.level.must_equal log_levels[:debug]
      end

      it "returns what was set" do
        value = logger.level = :debug
        value.must_equal :debug
      end
    end
  end
end
