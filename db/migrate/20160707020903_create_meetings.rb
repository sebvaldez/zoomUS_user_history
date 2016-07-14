class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :user_id
      t.string :uuid
      t.string :host_email
      t.string :id_of_meeting
      t.datetime :start_time
      t.datetime :end_time
      t.integer :participant_count
      t.boolean :has_pstn, :default => false
      t.boolean :has_voip, :default => false
      t.boolean :has_video, :default => false
      t.boolean :has_screen_share, :default => false
      t.integer :recording

    end
    add_index :meetings, :host_email
    add_index :meetings, :uuid
  end
end
