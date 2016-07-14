class Meeting < ActiveRecord::Base
	validates :uuid, presence: true, uniqueness: true
	belongs_to :users
	has_many :participants

end
