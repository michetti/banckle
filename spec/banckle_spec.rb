require 'spec_helper'

describe "Banckle" do
  describe "API" do
    before(:each) do
      @userid = "XXX"
      @password = "XXX"
      @api = Banckle::API.new(@userid, @password)
    end

    it "should allow a user to authenticate for conference product" do
      @api.authenticate("conference").should be_true
      @api.token.should_not be_nil
      @api.internal_userid.should_not be_nil
      @api.userid.should eq(@userid)
    end

    it "should allow an authenticated user to schedule a meeting and retrieve the meeting id" do
      @api.authenticate("conference").should be_true

      tomorrow = Time.now + (60  * 60 * 24)
      meeting_id = @api.create_scheduling_meeting("Testing Meeting", tomorrow)
      puts "Meeting Id: #{meeting_id}"

      meeting_id.should_not be_nil
      meeting_id.should_not be_zero
    end

    it "should know how to returng a meeting url" do
      fake_meeting_url = 123456
      Banckle::API.meeting_url(123456).should eq("https://meeting.banckle.com/meeting?id=#{fake_meeting_url}")
    end

  end
end
