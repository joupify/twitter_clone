require "test_helper"

class FollowerMailerTest < ActionMailer::TestCase
  test "new_follower" do
    mail = FollowerMailer.new_follower
    assert_equal "New follower", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
