class LinkedinGroup < ActiveRecord::Base
  has_many :user_groups
  has_many :users, through: :user_groups

  attr_accessible :linkedin_id, :linkedin_name, :name
end
