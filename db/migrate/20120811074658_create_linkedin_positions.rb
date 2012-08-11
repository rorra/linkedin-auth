class CreateLinkedinPositions < ActiveRecord::Migration
  def change
    create_table :linkedin_positions do |t|
      t.references :user
      t.references :linkedin_company

      t.integer :linkedin_id
      t.boolean :is_current
      t.date :start_date
      t.date :end_date
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
