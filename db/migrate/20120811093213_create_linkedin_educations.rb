class CreateLinkedinEducations < ActiveRecord::Migration
  def change
    create_table :linkedin_educations do |t|
      t.references :user

      t.integer :linkedin_id
      t.string :school_name
      t.string :field_of_study
      t.date :start_date
      t.date :end_date
      t.string :degree
      t.string :activities
      t.string :notes

      t.timestamps
    end
  end
end
