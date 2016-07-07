class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :user_id
      t.string :host_email
      t.datetime :start_time
      t.datetime :end_time
      t.string :uuid
      t.integer :participant_count

    end
    add_index :meetings, :host_email
  end
end
