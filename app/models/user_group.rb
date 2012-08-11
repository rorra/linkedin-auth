class UserGroup < ActiveRecord::Base
  belongs_to :linkedin_group
  belongs_to :user

  attr_accessible :linkedin_group, :linkedin_group_id, :user, :user_id, :membership_state, :linkedin_id
end
