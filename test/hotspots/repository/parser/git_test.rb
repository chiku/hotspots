require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', '..', 'minitest_helper')

module Hotspots::Repository
  describe "Parser::Git" do
    it "fetches a commit hash based on filter and time" do
      mock_git_driver = MiniTest::Mock.new
      options         = {:time => 10, :message_filters => ["Foo"]}
      git_parser      = Parser::Git.new mock_git_driver, options

      mock_git_driver.expect(:pretty_log, "SHA1\nSHA2", [:since_days => options[:time], :message_filter => "Foo"])

      git_parser.filtered_commit_hashes.must_equal(["SHA1", "SHA2"])

      assert mock_git_driver.verify
    end

    it "fetches multiple commit hashes" do
      options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
      git_parser = Parser::Git.new StubGitDriver.new, options

      git_parser.filtered_commit_hashes.must_equal(["SHA1", "SHA2", "SHA3"])
    end

    it "finds all affected files for a commit message" do
      mock_git_driver = MiniTest::Mock.new
      options         = {:time => 10, :message_filters => ["Foo"]}
      git_parser      = Parser::Git.new mock_git_driver, options

      mock_git_driver.expect(:pretty_log, "SHA1", [:since_days => options[:time], :message_filter => "Foo"])
      mock_git_driver.expect(:show_one_line_names, "SHA1 CommitMessage\nfile1\nfile2", [:commit_hash => "SHA1"])

      git_parser.files.must_equal(["file1", "file2"])

      assert mock_git_driver.verify
    end

    it "finds all affected files for multiple commit messages" do
      options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
      git_parser = Parser::Git.new StubGitDriver.new, options

      git_parser.files.must_equal(["file1", "file2", "file2", "file3", "file5", "file4"])
    end

    describe "handles line ending" do
      it "of type \r\n" do
        options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
        git_parser = Parser::Git.new StubGitDriver.new(:line_ending => "\r\n"), options

        git_parser.files.must_equal(["file1", "file2", "file2", "file3", "file5", "file4"])
      end

      it "of type \r" do
        options    = {:time => 10, :message_filters => ["Foo", "Bar"]}
        git_parser = Parser::Git.new StubGitDriver.new(:line_ending => "\r"), options

        git_parser.files.must_equal(["file1", "file2", "file2", "file3", "file5", "file4"])
      end
    end
  end

  describe "git driver stub" do
    it "has a sane pretty log" do
      driver = StubGitDriver.new
      driver.pretty_log(:time => 10, :message_filter => "Foo").must_equal "SHA1\nSHA2"
      driver.pretty_log(:time => 10, :message_filter => "Bar").must_equal "SHA2\nSHA3"
    end

    it "has a sane show one line names" do
      StubGitDriver.new.show_one_line_names(:commit_hash => "SHA2").
          must_equal "SHA1 commit message\nfile2\nfile3\nfile5"
      StubGitDriver.new(:line_ending => "\r\n").show_one_line_names(:commit_hash => "SHA2").
          must_equal "SHA1 commit message\r\nfile2\r\nfile3\r\nfile5"
    end
  end

  class StubGitDriver
    def initialize(options = {})
      line_ending = options[:line_ending] || "\n"
      @pretty_log_enum = ["SHA1#{line_ending}SHA2", "SHA2#{line_ending}SHA3"].cycle
      @commits = {
        "SHA1" => "SHA1 commit message#{line_ending}file1#{line_ending}file2",
        "SHA2" => "SHA1 commit message#{line_ending}file2#{line_ending}file3#{line_ending}file5",
        "SHA3" => "SHA1 commit message#{line_ending}file4",
      }
    end

    def pretty_log(options)
      @pretty_log_enum.next
    end

    def show_one_line_names(options)
      @commits[options[:commit_hash]]
    end
  end
end
