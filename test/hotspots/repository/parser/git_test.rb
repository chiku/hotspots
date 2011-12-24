require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', '..', '..', 'lib', 'hotspots', 'repository', 'parser', 'git')

module Hotspots::Repository
  describe "Parser::Git test" do
    it "fetches a commit hash based on filter and time" do
      mock_git_driver = MiniTest::Mock.new
      options         = {:time => 10, :message_filter => ["Foo"]}
      git_parser      = Parser::Git.new mock_git_driver, options

      mock_git_driver.expect(:pretty_log, "SHA1\nSHA2", [:since_days => options[:time], :message_filter => "Foo"])

      git_parser.filtered_commit_hashes.must_equal("Foo" => ["SHA1", "SHA2"])

      assert mock_git_driver.verify
    end

    it "fetches multiple commit hashes" do
      options    = {:time => 10, :message_filter => ["Foo", "Bar"]}
      git_parser = Parser::Git.new StubGitDriver, options

      git_parser.filtered_commit_hashes.must_equal("Foo" => ["SHA1", "SHA2"], "Bar" => ["SHA2", "SHA3"])
    end
  end

  describe "git driver stub" do
    it "is sane" do
      StubGitDriver.pretty_log.must_equal "SHA1\nSHA2"
      StubGitDriver.pretty_log.must_equal "SHA2\nSHA3"
    end
  end

  class StubGitDriver
    @pretty_log_enum = ["SHA1\nSHA2", "SHA2\nSHA3"].cycle

    class << self
      def pretty_log(*args)
        @pretty_log_enum.next
      end
    end
  end
end
