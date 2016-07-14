require 'representable/hash'

module MeetingRepresenter

	include Representable::Hash
	include Representable::Hash::AllowSymbols

	property :uuid
	property :host_email, as: :email
	property :id_of_meeting, as: :id
	property :start_time
	property :end_time
	property :duration
	property :participant_count, as: :participants
	property :has_pstn
	property :has_voip
	property :has_screen_share
end