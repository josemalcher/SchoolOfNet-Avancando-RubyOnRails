class CreatePeople < ActiveRecord::Migration[5.1]
  def change
    create_table :people do |t|
      t.string :name

      t.timestamps

      t.belongs_to :passaports, index: true
    end
  end
end
