require File.join(File.expand_path(File.dirname(__FILE__)), '..', 'minitest_helper')

class Hotspots
  describe "Configuration" do
    let(:configuration) { Configuration.new }

    describe "#initialize" do
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

      it "defaults exit code to nil" do
        configuration.exit_strategy.code.must_equal nil
      end

      it "defaults exit message to empty string" do
        configuration.exit_strategy.message.must_equal ""
      end
    end
  end
end
