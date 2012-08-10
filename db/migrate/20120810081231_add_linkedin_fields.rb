class AddLinkedinFields < ActiveRecord::Migration
  def change
    add_column :users, :linkedin_uid, :integer
    add_column :users, :linkedin_token, :string
    add_column :users, :linkedin_secret, :string

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :headline, :string
    add_column :users, :industry, :string
    add_column :users, :picture_url, :string
    add_column :users, :public_profile_url, :string
  end
end
