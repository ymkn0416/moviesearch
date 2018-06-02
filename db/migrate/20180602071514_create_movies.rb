class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.integer :theaters_Id
      t.text :title
      t.boolean :dub
      t.boolean :imax
      t.boolean :threeD
      t.boolean :fourDx

      t.timestamps
    end
  end
end
