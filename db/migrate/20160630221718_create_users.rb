class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :zoom_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :enable_large
      t.integer :large_capacity
      t.boolean :enable_webinar
      t.integer :webinar_capacity
      t.string :pmi

      t.timestamps null: false
    end
    add_index :users, :zoom_id
    add_index :users, :email
  end
end
