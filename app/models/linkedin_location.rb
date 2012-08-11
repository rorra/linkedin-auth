class LinkedinLocation < ActiveRecord::Base
  has_many :users
  has_many :linkedin_connections

  attr_accessible :code, :name
end
