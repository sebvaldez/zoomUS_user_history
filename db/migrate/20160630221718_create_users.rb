class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zoom_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :enable_large, :default=> false
      t.integer :large_capacity
      t.boolean :enable_webinar, :default=> false
      t.integer :webinar_capacity
      t.string :pmi
      t.boolean :status, :default => true   # to show if user exists/Live
      t.timestamps null: false
    end
    add_index :users, :zoom_id
    add_index :users, :email
  end
end
