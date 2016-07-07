
### API ZOOM WRAPPER ###
# Creates
def zoomAPI( endpoint, params = {} )
  # Environment Vars
  apiKey = ENV['Zoom_API_Key']
  apiSecret = ENV['Zoom_API_Secret']
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

  desc "Get meetings from specifed params"
  task :get_meetings, [:when] => :environment do |items, args|
    from = ''
    to = ''
    # Get the current day
    now = Date.today()
    if args.when == "first"
      from = Date.new( now.year, now.month, 1 )
      to = Date.new( now.year, now.month, now.day + 1 )
    elsif args.when == "today"
      from = Date.new( now.year, now.month, now.day )
      to = Date.new( now.year, now.month, now.day + 1 )
    end

    # User args to specify what days we want

    # Create URL to POST to ZOOM API

    # return size of "total records"
    print "Today is #{now}"
    print "\n"
    print "You want meetings from : #{from} => #{to}"
    print"\n"
  end

  desc "Creates users from zoom and loads to dev db, takes count"
  task :load_users, [:number] => :environment do |items, args|
    user = ''
    # Create url to POST to zoom
    url = zoomAPI('user/list', :page_size => args.number)

    print "Rake will load #{args.number} zoom users into the db"
    print "\n"
    # Print toal number of users
    response = HTTParty.post( url )
    print "Zooms current total users are #{response['total_records']}"
    print "\n"
    # Create a user from the zoom USER list
    response['users'].each do |user|
      user = User.new(
      :zoom_id=>user['id'],
      :first_name =>user['first_name'],
      :last_name =>user['last_name'],
      :email =>user['email'],
      :pmi =>user['pmi'].to_s
      )
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



  desc "A test task for debugging"
  task :test, [:word, :word2] => :environment do |items, args|
    print "you word is: #{args.word} & #{args.word2}"
  end

















end
