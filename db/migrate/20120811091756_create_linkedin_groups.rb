class CreateLinkedinGroups < ActiveRecord::Migration
  def change
    create_table :linkedin_groups do |t|
      t.integer :linkedin_id
      t.string :name

      t.timestamps
    end
  end
end
