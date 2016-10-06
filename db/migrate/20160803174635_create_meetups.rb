class CreateMeetups < ActiveRecord::Migration
  def change
    create_table :meetups do |t|
      t.integer :user_id
      t.string :name, null: false
      t.string :description, null: false
      t.string :location, null: false

      t.timestamps
    end
  end
end
