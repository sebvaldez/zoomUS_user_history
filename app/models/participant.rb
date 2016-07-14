class Participant < ActiveRecord::Base
	validates :join_time, presence: true, uniqueness: true
	belongs_to :meetings

end
