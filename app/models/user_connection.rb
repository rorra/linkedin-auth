class UserConnection < ActiveRecord::Base
  belongs_to :user
  belongs_to :linkedin_connection
end
