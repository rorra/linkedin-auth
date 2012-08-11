class LinkedinPosition < ActiveRecord::Base
  belongs_to :user
  belongs_to :linkedin_company

  attr_accessible :linkedin_id, :linkedin_company, :linkedin_company_id, :title, :summary, :start_date, :end_date,
                  :is_current
end
