class CreatePassaports < ActiveRecord::Migration[5.1]
  def change
    create_table :passaports do |t|
      t.string :country

      t.timestamps
    end
  end
end
