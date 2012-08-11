class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.references :user
      t.references :linkedin_group

      t.string :linkedin_id
      t.string :membership_state

      t.timestamps
    end
  end
end
