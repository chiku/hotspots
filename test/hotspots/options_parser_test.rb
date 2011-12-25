require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'hotspots', 'options_parser')
require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'lib', 'hotspots', 'logger')

module Hotspots
  describe "OptionsParser" do
    before do
      @parser = OptionsParser.new
    end

    describe "defaults" do
      it "repository to current path" do
        @parser.parse[:repository].must_equal "."
      end

      it "time to 15" do
        @parser.parse[:time].must_equal 15
      end

      it "file filter to empty string" do
        @parser.parse[:file_filter].must_equal ""
      end

      it "message filters to array with an empty string" do
        @parser.parse[:message_filters].must_equal [""]
      end

      it "cutoff to 0" do
        @parser.parse[:cutoff].must_equal 0
      end

      it "verbose to nil" do
        @parser.parse[:verbose].must_equal false
      end

      it "exit code to nil" do
        @parser.parse[:exit][:code].must_equal nil
      end

      it "exit message to empty string" do
        @parser.parse[:exit][:message].must_equal ""
      end
    end

    ["--repository", "--repo", "-r"].each do |option|
      describe option do
        it "sets the specified value repository" do
          @parser.parse(option, "rails")[:repository].must_equal "rails"
        end

        it "sets empty repository when missing" do
          @parser.parse(option)[:repository].must_equal ""
        end
      end
    end

    ["--time", "--ti", "-t"].each do |option|
      describe option do
        it "sets the specified time to consider" do
          @parser.parse(option, "8")[:time].must_equal 8
        end

        it "sets zero time when missing" do
          @parser.parse(option)[:time].must_equal 0
        end
      end
    end

    ["--cutoff", "--cut", "-c"].each do |option|
      describe option do
        it "sets the specified cutoff" do
          @parser.parse(option, "5")[:cutoff].must_equal 5
        end

        it "sets zero cutoff when missing" do
          @parser.parse(option)[:cutoff].must_equal 0
        end
      end
    end

    ["--file-filter", "--file", "-f"].each do |option|
      describe option do
        it "sets the specified file-filter" do
          @parser.parse(option, "rb")[:file_filter].must_equal "rb"
        end

        it "sets empty file-filter when missing" do
          @parser.parse(option)[:file_filter].must_equal ""
        end
      end
    end

    ["--message-filter", "--message", "-m"].each do |option|
      describe option do
        it "sets the specified message filters" do
          @parser.parse(option, "cleanup|defect")[:message_filters].must_equal ["cleanup", "defect"]
        end

        it "sets empty message-filter when missing" do
          @parser.parse(option)[:message_filters].must_equal []
        end
      end
    end

    ["--verbose", "-v"].each do |option|
      describe option do
        it "sets the console logger" do
          @parser.parse(option)[:verbose].must_equal true
        end
      end
    end

    ["--help", "-h"].each do |option|
      describe option do
        it "sets exit code to zero" do
          @parser.parse(option)[:exit][:code].must_equal 0
        end

        it "sets an exit message" do
          @parser.parse(option)[:exit][:message].wont_be_empty
        end
      end
    end

    describe "on a invalid option" do
      before do
        @options = @parser.parse("--invalid-option")
      end

      it "sets an exit code" do
        @options[:exit][:code].must_equal 1
      end

      it "sets an exit message" do
        @options[:exit][:message].wont_be_empty
      end
    end

    describe "on a invalid argument" do
      before do
        @options = @parser.parse("--repo", "")
      end

      it "sets an exit code" do
        @options[:exit][:code].must_equal 1
      end

      it "sets an exit message" do
        @options[:exit][:message].wont_be_empty
      end
    end
  end
end