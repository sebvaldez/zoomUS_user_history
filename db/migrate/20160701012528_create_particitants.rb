class CreateParticitants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :meeting_id
      t.string :uuid
      t.string :id_of_meeting
      t.string :user_name
      t.string :device
      t.string :ip_address
      t.string :country_name
      t.string :city
      t.datetime :join_time
      t.datetime :leave_time
    end
  end
end
