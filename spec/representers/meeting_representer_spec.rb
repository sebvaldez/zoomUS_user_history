require 'spec_helper'
require 'rails_helper'

describe MeetingRepresenter do
	it 'maps email Meeting attribute correctly' do
		item = {
			:email => 'svaldez@solarcity.com'
		}
		meeting = Meeting.new.extend(MeetingRepresenter).from_hash(item)

		expect(meeting.host_email).to eq('svaldez@solarcity.com')
	end
end