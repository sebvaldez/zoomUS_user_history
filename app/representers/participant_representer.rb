require 'representable/hash'

module ParticipantRepresenter

	include Representable::Hash
	include Representable::Hash::AllowSymbols

	property :user_name
	property :device
	property :ip_address
	property :country_name, as: :cn
	property :city
	property :join_time
	property :leave_time

end