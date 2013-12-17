class CreateBooklists < ActiveRecord::Migration
  def change
    create_table :booklists do |t|
      t.string :isbn
      t.string :name
      t.string :place
      t.string :room
      t.string :shelf
      t.date :acquired_at
      t.date :checked_at
      t.string :borrowed_by

      t.timestamps
    end
  end
end
