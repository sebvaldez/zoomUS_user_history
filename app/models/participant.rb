class Participant < ActiveRecord::Base

	validates_uniqueness_of :join_time, scope: [:uuid, :user_name ]

	belongs_to :meetings

	def self.search(param)
		return Participant.none if param.blank?
		(meeting_matches(param)).to_a
	end

	def self.meeting_matches(param)
		matches('uuid', param)
	end

	def self.matches(fieldname, param)
		where("#{fieldname} = ?", param)
	end

end

