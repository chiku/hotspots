require File.join(File.expand_path(File.dirname(__FILE__)), "..", "..", "minitest_helper")

module Hotspots::Repository
  class GitDriverStub
    def initialize
      @pretty_log = ["SHA1\nSHA2", "SHA2\nSHA3"]
      @commits = {
        "SHA1" => "SHA1 commit message\nfile1\nfile2",
        "SHA2" => "SHA1 commit message\nfile2\nfile3\nfile5",
        "SHA3" => "SHA1 commit message\nfile4",
      }
      @pretty_log_cycle = 0
    end

    def pretty_log(options)
      @pretty_log[@pretty_log_cycle].tap do
        @pretty_log_cycle = (@pretty_log_cycle + 1) % 2
      end
    end

    def show_one_line_names(options)
      @commits[options[:commit_hash]]
    end
  end

  describe GitDriverStub do
    subject { GitDriverStub.new }

    describe "#pretty_log" do
      it "is sane" do
        subject.pretty_log(:time => 10, :message_filter => "Foo").must_equal "SHA1\nSHA2"
        subject.pretty_log(:time => 10, :message_filter => "Bar").must_equal "SHA2\nSHA3"
      end
    end

    describe "#show_one_line_names" do
      it "is sane" do
        subject.show_one_line_names(:commit_hash => "SHA2").
            must_equal "SHA1 commit message\nfile2\nfile3\nfile5"
      end
    end
  end

  describe "GitParser" do
    describe "#filtered_commit_hashes" do
      it "fetches a commit hash based on filter and time" do
        mock_git_driver = MiniTest::Mock.new
        options         = {:time => 10, :message_filters => ["Foo"]}
        git_parser      = GitParser.new mock_git_driver, options

        mock_git_driver.expect(:pretty_log, "SHA1\nSHA2", [:since_days => options[:time], :message_filter => "Foo"])

        git_parser.filtered_commit_hashes.must_equal(["SHA1", "SHA2"])

        mock_git_driver.verify.must_equal true
      end

      it "fetches multiple commit hashes" do
        options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
        git_parser = GitParser.new GitDriverStub.new, options

        git_parser.filtered_commit_hashes.must_equal(["SHA1", "SHA2", "SHA3"])
      end
    end

    describe "#files" do
      it "finds all affected files for a commit message" do
        mock_git_driver = MiniTest::Mock.new
        options         = {:time => 10, :message_filters => ["Foo"]}
        git_parser      = GitParser.new mock_git_driver, options

        mock_git_driver.expect(:pretty_log, "SHA1", [:since_days => options[:time], :message_filter => "Foo"])
        mock_git_driver.expect(:show_one_line_names, "SHA1 CommitMessage\nfile1\nfile2", [:commit_hash => "SHA1"])

        git_parser.files.must_equal(["file1", "file2"])

        mock_git_driver.verify.must_equal true
      end

      it "finds all affected files for multiple commit messages" do
        options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
        git_parser = GitParser.new GitDriverStub.new, options

        git_parser.files.must_equal(["file1", "file2", "file2", "file3", "file5", "file4"])
      end
    end
  end
end
