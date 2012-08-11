class CreateLinkedinLocations < ActiveRecord::Migration
  def change
    create_table :linkedin_locations do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
