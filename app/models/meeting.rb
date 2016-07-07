class Meeting < ActiveRecord::Base
  belongs_to :users
  has_many :participants

end
