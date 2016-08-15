class Participant < ActiveRecord::Base

	validates_uniqueness_of :join_time, scope: [:uuid, :user_name ]

	belongs_to :meetings

end