class CreateLinkedinCompanies < ActiveRecord::Migration
  def change
    create_table :linkedin_companies do |t|
      t.integer :linkedin_id
      t.string :name
      t.string :company_type
      t.string :size
      t.string :industry
      t.string :ticker

      t.timestamps
    end
  end
end
