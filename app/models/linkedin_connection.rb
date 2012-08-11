class LinkedinConnection < ActiveRecord::Base
  has_many :user_connections
  has_many :users, through: :user_connections
  belongs_to :linkedin_location

  attr_accessible :location_id, :linkedin_id, :first_name, :last_name, :headline, :industry, :picture_url,
                  :public_profile_url
end
