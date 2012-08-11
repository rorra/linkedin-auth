class LinkedinCompany < ActiveRecord::Base
  has_many :linkedin_positions
  has_many :users, through: :linkedin_positions

  attr_accessible :linkedin_id, :name, :company_type, :size, :industry, :ticker
end
