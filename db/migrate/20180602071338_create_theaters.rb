class CreateTheaters < ActiveRecord::Migration[5.2]
  def change
    create_table :theaters do |t|
      t.text :name
      t.text :url

      t.timestamps
    end
  end
end
