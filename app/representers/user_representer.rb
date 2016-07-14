require 'representable/hash'

module UserRepresenter
	include Representable::Hash
	include Representable::Hash::AllowSymbols

	property :zoom_id, as: :id
	property :first_name
	property :last_name
	property :email
	property :enable_large
	property :large_capacity
	property :enable_webinar
	property :webinar_capacity
	property :pmi

end