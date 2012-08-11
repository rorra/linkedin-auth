class LinkedinEducation < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user, :user_id, :linkedin_id, :school_name, :field_of_study, :start_date, :end_date, :degree,
                  :activities, :notes
end
