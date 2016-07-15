require 'representable/hash'

module MeetingRepresenter

	include Representable::Hash
	include Representable::Hash::AllowSymbols

	property :uuid
	
	property :host_email, as: :email,
		setter: ->(fragment:, represented:, **) { represented.host_email = fragment.downcase }

	property :id_of_meeting, as: :id
	property :start_time
	property :end_time
	property :participant_count, as: :participants
	property :has_pstn
	property :has_voip
	property :has_video
	property :has_screen_share
	property :recording
end