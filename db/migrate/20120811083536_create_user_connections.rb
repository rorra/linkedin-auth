class CreateUserConnections < ActiveRecord::Migration
  def change
    create_table :user_connections do |t|
      t.references :user
      t.references :linkedin_connection

      t.timestamps
    end
    add_index :user_connections, [:user_id, :linkedin_connection_id]
  end
end
