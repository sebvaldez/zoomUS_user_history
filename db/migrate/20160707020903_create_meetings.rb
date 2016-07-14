class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.integer :user_id
      t.string :uuid
      t.string :host_email
      t.string :id_of_meeting
      t.string :type
      t.datetime :start_time
      t.datetime :end_time
      t.integer :participant_count

      t.string :duration
      t.boolean :has_pstn
      t.boolean :has_voip
      t.boolean :has_screen_share, :default => false

    end
    add_index :meetings, :host_email
  end
end
