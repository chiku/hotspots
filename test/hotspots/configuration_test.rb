require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'minitest_helper')

class Hotspots
  class StubLogger
    attr_accessor :level
    def initialize
      @level = :uninitialized
    end
  end

  describe "Configuration" do
    describe "#initialize" do
      let(:stub_logger) { StubLogger.new }
      let(:configuration) { Configuration.new(:logger => stub_logger, :info_log_level => :info_level, :error_log_level => :error_level) }

      it "defaults repository to the current path" do
        configuration.repository.must_equal "."
      end

      it "defaults time to 15" do
        configuration.time.must_equal 15
      end

      it "defaults file filter to empty string" do
        configuration.file_filter.must_equal ""
      end

      it "defaults message filters to array with an empty string" do
        configuration.message_filters.must_equal [""]
      end

      it "defaults cutoff to 0" do
        configuration.cutoff.must_equal 0
      end

      it "set a logger" do
        configuration.logger.wont_be :nil?
      end

      it "defaults the logger level to error" do
        configuration.logger.level.must_equal :error_level
      end

      it "defaults exit code to nil" do
        configuration.exit_strategy.code.must_equal nil
      end

      it "defaults exit message to empty string" do
        configuration.exit_strategy.message.must_equal ""
      end
    end

    describe "#initialize without default logger" do
      let(:configuration) { Configuration.new }

      it "set a logger" do
        configuration.logger.wont_be :nil?
      end

      it "defaults the logger level to error" do
        configuration.logger.level.must_equal ::Logger::ERROR
      end
    end
  end
end
