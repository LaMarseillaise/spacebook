class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.integer :user_id, null: false
      t.string  :school
      t.string  :hometown
      t.string  :current_town
      t.string  :phone_number
      t.text    :quotes
      t.text    :about
      t.integer :photo_id
      t.integer :cover_photo_id

      t.timestamps
    end
    add_index :profiles, :user_id, :unique => true
  end
end
