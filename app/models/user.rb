class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  has_many :meetings

  def self.search(param)
  	return User.none if param.blank?

  	param.strip!
  	param.downcase!
  	(first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end

  def self.first_name_matches(param)
    matches('first_name', param)
  end

  def self.last_name_matches(param)
    matches('last_name', param)
  end

  def self.email_matches(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("lower(#{field_name}) LIKE ?", "%#{param}%")
  end

end
