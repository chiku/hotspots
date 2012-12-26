require File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', '..', 'minitest_helper')

module Hotspots::Repository
  describe "Command::Git" do
    describe "Log" do
      describe "#build" do
        describe "when message filter exists" do
          it "includes a grep clause" do
            log_command = Command::Git::Log.new :since_days => 20, :message_filter => "Foo|Bar"
            log_command.build.must_equal 'git log --pretty="%H" --since="20 days ago" --grep "Foo|Bar"'
          end
        end

        describe "when message filter doesn't exist" do
          it "doesn't have a grep clause" do
            log_command = Command::Git::Log.new :since_days => 20
            log_command.build.must_equal 'git log --pretty="%H" --since="20 days ago"'
          end
        end

        describe "when message filter is set to an empty string" do
          it "grep clause is ignored" do
            log_command = Command::Git::Log.new :since_days => 20, :message_filter => ""
            log_command.build.must_equal 'git log --pretty="%H" --since="20 days ago"'
          end
        end
      end
    end

    describe "Show" do
      describe "#build" do
        it "constructs a git show with one-line format" do
          show_command = Command::Git::Show.new :commit_hash => "abc123"
          show_command.build.must_equal 'git show --oneline --name-only abc123'
        end
      end
    end
  end
end
