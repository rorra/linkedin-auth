class CreateLinkedinConnections < ActiveRecord::Migration
  def change
    create_table :linkedin_connections do |t|
      t.references :location

      t.string :linkedin_id

      t.string :first_name
      t.string :last_name
      t.string :headline
      t.string :industry
      t.string :picture_url
      t.string :public_profile_url

      t.timestamps
    end
  end
end
