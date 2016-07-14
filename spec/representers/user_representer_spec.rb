require 'spec_helper'
require 'rails_helper'

describe UserRepresenter do
	
	it 'maps User attributes correctly' do

		#example zoom hash return
		user  = {
			"id"=>"--9GQhxsTqyC0S28QS3LtA",
			"email"=>"rzeytoonian@solarcity.com",
			"first_name"=>"Rhona",
			"last_name"=>"Zeytoonian",
			"pic_url"=>"",
			"type"=>2,
			"disable_chat"=>false,
			"disable_private_chat"=>false,
			"enable_e2e_encryption"=>false,
			"enable_silent_mode"=>false,
			"disable_group_hd"=>false,
			"disable_recording"=>false,
			"enable_large"=>false,
			"large_capacity"=>0,
			"enable_webinar"=>false,
			"webinar_capacity"=>0,
			"disable_feedback"=>false,
			"disable_jbh_reminder"=>false,
			"enable_cmr"=>false,
			"enable_auto_recording"=>false,
			"enable_cloud_auto_recording"=>false,
			"enable_breakout_room"=>false,
			"verified"=>1,
			"pmi"=>6326240788,
			"meeting_capacity"=>0,
			"timezone"=>"America/New_York",
			"created_at"=>"2015-02-02T20:00:27Z",
			"lastClientVersion"=>"3.5.49839.0509(win)",
			"lastLoginTime"=>"2016-06-28T20:27:45Z",
			"token"=>"",
			"zpk"=>""
		}

		user = User.new().extend(UserRepresenter).from_hash(user)

		expect(user.zoom_id).to eq('--9GQhxsTqyC0S28QS3LtA')

	end

end