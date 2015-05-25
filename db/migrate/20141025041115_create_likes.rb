class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :likable, polymorphic: true, null: false
      t.integer    :liker_id, null: false

      t.timestamps
    end

    add_index :likes, [:likable_type, :likable_id, :liker_id], unique: true
    add_column :posts, :likes_count, :integer, default: 0, null: false
  end
end
