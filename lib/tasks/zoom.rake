
### API ZOOM WRAPPER ###
# Creates
def zoomAPI( endpoint, params = {} )
  # Environment Vars
  apiKey = ENV['ZOOM_API_KEY']
  apiSecret = ENV['ZOOM_API_SECRET']
  baseUri = "https://api.zoom.us/"
  dataType = "data_type=JSON"
  version = 'v1/'
  results = Array.new

  # Adds Key, Secret and DataType to passed Array
  results = [
    "api_key=#{apiKey}",
    "api_secret=#{apiSecret}",
    "#{dataType}"
  ]
  # ADD go through hash and push key and values to results array
  params.each do |key, value|
    results.push("#{key}=#{value}")
  end

  # Create and reurn one Url for HTTPARY to use
  url = "#{baseUri}" + "#{version}" +  "#{endpoint}" + "?" +  results.join('&')
  return url
end
### ### ###

### Add capitalize? methods to string class ###
class String
  def capitalized?
    chars.first == chars.first.upcase
  end
end
### ### ###
## Check for valid string DateTime, flip to datetime
def valid_time(time)
  time.empty? ? time = "N/A" : time = DateTime.parse(time)
end
### #### ###

namespace :zoom do

  desc "Get Zoom User ID using email"
  task :id_by_email, [:email] => :environment do |item ,args|
    # Create API request
    url = zoomAPI( 'user/getbyemail', :login_type=>101, :email=>"#{args.email}" )
    # POST request to Zoom base API URL
    response = HTTParty.post(url)
    # Save ID
    id = response['id']
    print " USER ID is : #{id}"
    print "\n"
  end

  desc "Creates users from zoom and loads to dev db, takes count"
  task :load_users, [:number] => :environment do |items, args|

    # Create url to POST to zoom
    url = zoomAPI('user/list', :page_size => args.number)

    print "Rake will load #{args.number} zoom users into the db \n"
    # Print toal number of users
    response = HTTParty.post( url )
    print "Zooms current total users are #{response['total_records']} \n"

    # Create a user from the zoom USER list
    response['users'].each do |user|
      # Create new user instance
      user = User.new().extend(UserRepresenter).from_hash(user)
      #Validate if the user exists in the database
      if user.valid?
        user.save
        print "#{user['first_name']} Create in Local Database!"
        print "\n"
      else
        print "#{user['email'].split("@")[0]} - > #{user.errors.messages}"
        print "\n"
      end
    end
  end

  desc "Creates meetings to db from specifed time"
  task :get_meetings, [:when, :period, :number] => :environment do |items, args|
    from = ''
    to = ''

    # Handle users input from when EX: jan -> Jan
    "#{args.when}".capitalized? ? month = "#{args.when}" : month = "#{args.when}".capitalize

    # Get integer of argument month
    month = Date::ABBR_MONTHNAMES.index(month)

    # Get the current day
    now = Date.today()
    if args.period == "all"
      from = Date.new( now.year, month, 1 )
      to = Date.new( now.year, month, 1 ).next_month.prev_day
    elsif args.period == "today"
      from = Date.new( now.year, month, 1 )
      to = Date.new( now.year, month, now.day + 1)
    end
    print "You want meetings from : #{from} => #{to} \n"
    print "You said you only want #{args.number} meeting(s) \n"

    # Set page number
    page_number = 1

    meetingList = []

    # Create URL to POST to ZOOM API
    meet_url = zoomAPI(
      'metrics/meetings',
      :type=>2,
      :from => from,
      :to => to,
      :page_size=>30,
      :page_number=>page_number )
    response = HTTParty.post( meet_url )
    print "There are a total of: #{response['total_records']} for #{args.when} \n \n"
    meetingList = response['meetings']

    # Grow meeting until page count is last page
    while response['page_number'] < response['page_count'] do
      page_number += 1
      print "Requesting Page: #{page_number}"
      meet_url = zoomAPI(
        'metrics/meetings',
        :type=>2,
        :from => from,
        :to => to,
        :page_size=>30,
        :page_number=>page_number )
      response = HTTParty.post( meet_url )
      meetingList += response['meetings']
      print " Meeting size is now: #{meetingList.size} \n"
    end
    if response.code == 200
      # CREATE meetings in DB
      response['meetings'].each do |item|
        meeting = Meeting.new.extend(MeetingRepresenter).from_hash(item)
        print "\n"
        print "***** MEETING ***** \n"
        print "UUID: #{meeting['uuid']} \n"
        print "HOST: #{meeting['host_email']} \n"
        print "Participants: #{meeting['participant_count']} \n"
        print "\n"

        # Get more Detail of meeting plus all participants
        participant_url = zoomAPI(
          'metrics/meetingdetail',
          :meeting_id => URI.escape(meeting['uuid'], /\W/),
          :type => 2,
          :page_size => 300
        )
        print participant_url 
        print "\n"
        print "\n"

        participant_response = HTTParty.post( participant_url )
        participant_response = participant_response.parsed_response
        unless participant_response['participants'].nil?
          participant_response['participants'].each do |user|
            participant = Participant.new(:uuid =>participant_response['uuid'], :id_of_meeting=>participant_response['id']).extend(ParticipantRepresenter).from_hash(user)
            print "***** PARTICIPANT ***** \n"
            print "UUID : #{participant['uuid']} \n"
            print "NAME: #{participant['user_name']} \n"
            print "LEFT: #{participant['leave_time']} \n"
            print "\n"
            if participant.valid?
              participant.save
              print "***** #{participant['user_name']} SAVED! ***** \n \n"
            else
              print "#{participant.errors.messages} \n"
            end
          end
          print "***** END MEETING ***** \n \n"
        else
          print "NO Participants for #{meeting.uuid} \n"
        end
        if meeting.valid?
          meeting.save
          print "***** #{meeting['uuid']} SAVED! ***** \n"
        else
          print "#{meeting.errors.messages} \n"
          print "\n"
        end
      end
    else
      print "There was an issue with makeing the API request \n \n"

    end
  end

  desc "Link User table rows to Meeting table rows on match of email"
  task :link_usermeetings => :environment do

    # Target only nil user_id meetings
    meeting_array = Meeting.all.where(:user_id => nil)

    User.all.each do |user|
      users_meetings = meeting_array.all.where(:host_email => user.email )
      users_meetings.map{|meeting| meeting.update_attribute(:user_id, user.id); meeting.save }
      print "saved #{user.meetings.size} to #{user.email}\n\n"
    end
  end

  desc "Link Meeting table to participants "
  task :link_meetingparticipants => :environment do
    # Target only nil meeting_id participants
    new_participant_array = Participant.all.where(:meeting_id => nil)

    Meeting.all.each do |meeting|
      participant_array = new_participant_array.all.where(:uuid => meeting.uuid)
      participant_array.map{|part| part.update_attribute(:meeting_id, meeting.id); part.save}
      print "Linked #{meeting.participants.size} participants to #{meeting.uuid}\n\n"
    end
  end

  desc "Update the :status IF users does not exit from zoom, add IF vise versa"
  task :update_all_users => :environment do
    print "UPDATING ALL LOCAL DB USERS\n\n"
    # Get Total users
    url = zoomAPI('user/list', :page_size=>1)
    response = HTTParty.post( url )
    all_users = response['total_records']

    # Get all current zoom users
    url  = zoomAPI('user/list', :page_size => all_users )
    response = HTTParty.post( url )
    all_users = response['users']
    print "Current Zoom user base is #{all_users.size}\n"

    # Create array of zoom ids
    all_zoom_ids = []
    all_users.map{ |user| all_zoom_ids.push( user['id'] ) }

    # Set all Local DB users :status to false
    User.all.each.map{ |user| user.update_attribute(:status, false) }
    og_count = User.all.size
    print "#{og_count} Local DB users status's were mafe false \n"

    # Map and update status on user
    new_users = [] # array to hold ids of new users
    not_found = 0
    all_zoom_ids.map do |id|

      unless user = User.all.find_by(:zoom_id=> id)
        print "#{id} | NOT FOUND, STATUS FALSE | \n\n"
        not_found = not_found + 1
        new_users.push(id)
      else
        user.update_attribute(:status, true)        
      end

    end
    print "#{new_users.size} not found \n\n"
    print "#{og_count - User.all.where(:status => true).size} Users are NOW IN-ACTIVE\n\n"

    # Create a user from array
    new_users.each do |user|

      # Get user hash from zoom
      url = zoomAPI('user/get', :id => user)
      response = HTTParty.post( url )

      # Create new user instance
      new_user = User.new().extend(UserRepresenter).from_hash(response)

      #Validate if the user exists in the database
      if new_user.valid?
        new_user.save
        print "#{new_user['first_name']} Create in Local Database!\n\n"
      else
        print "#{new_user.first_name} | #{new_user.zoom_id} NOT ADDED!\n"
        print "#{new_user['email'].split("@")[0]} - > #{new_user.errors.messages}\n\n"
      end
    end



  end

  desc "A test task for debugging"
  task :test, [:word] => :environment do |items, args|
  end






























end