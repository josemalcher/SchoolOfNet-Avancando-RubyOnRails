class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :page

      t.timestamps

      t.belongs_to :author, index: true
    end
  end
end
