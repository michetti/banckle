require 'cgi'
require 'json'
require 'open-uri'
require "banckle/version"

module Banckle

 class API

   attr_reader :userid, :internal_userid, :token

   def initialize(userid, password)
     @token = nil
     @userid = userid
     @password = password
     @internal_userid = nil

     @apps_url = "https://apps.banckle.com/api"
     @conference_url = "https://apps.banckle.com/meeting/api"
   end

   def authenticate(product)
     parts = []
     parts << "password=#{@password}"
     parts << "userid=#{@userid}"
     parts << "product=#{product}"

     json = open_and_parse("#{@apps_url}/authenticate", parts)

     if json["success"]
       @token = json["return"]["token"]
       @internal_userid = json["return"]["userId"]
       return true
     end

     @token = nil
     return false
   end

   def meeting_now(config = {})
     config = {duration: 60, record: false}.merge(config)

     parts = []
     parts << "subject=#{escape(config[:subject].to_s)}"
     parts << "duration=#{config[:duration].to_s}"
     parts << "attendees=#{config[:attendees].to_s}"
     parts << "password=#{escape(config[:password].to_s)}"
     parts << "welcome=#{escape(config[:welcome].to_s)}"
     parts << "hostId=#{config[:host_id].to_s}"
     parts << "token=#{@token}"
     parts << "record=#{config[:record].to_s}"

     json = open_and_parse("#{@conference_url}/meetingnow", parts)

     if json["success"]
       # return the meeting id
       return json["return"]["id"].to_i
     end

     return nil
   end

   def create_scheduling_meeting(subject, start, config = {})
     config = {v: 1, duration: 60, record: false, recurring: false, host_id: @internal_userid}.merge(config)

     parts = []
     parts << "v=#{config[:v].to_s}"
     parts << "starttime=#{start.to_i * 1000}"
     parts << "subject=#{subject.to_s}"
     parts << "duration=#{config[:duration].to_s}"
     parts << "attendees=#{config[:attendees].to_s}"
     parts << "password=#{config[:password].to_s}"
     parts << "welcome=#{config[:welcome].to_s}"
     parts << "recurring=#{config[:recurring] ? '1' : '0'}"
     parts << "hostId=#{config[:host_id].to_s}"
     parts << "token=#{@token}"
     parts << "record=#{config[:record].to_s}"

     json = open_and_parse("#{@conference_url}/createSchedulingMeeting", parts)
     puts json

     if json["success"]
       # return the meeting id
       return json["return"]["id"].to_i
     end

     return nil
   end

   def self.meeting_url(id)
     return "https://meeting.banckle.com/meeting?id=#{id}"
   end

   private
     def escape(param)
       return CGI.escape(param)
     end

     def open_and_parse(base_url, parts)
       url = "#{base_url}?#{parts.join("&")}"
       #puts url

       file = open(url)
       json = JSON.parse(file.read)
       #puts json

       return json
     end
  end
end
