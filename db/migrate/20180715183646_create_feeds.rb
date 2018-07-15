class CreateFeeds < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds do |t|
      t.string :url, null: false, unique: true
      t.string :title, null: false
      t.string :image

      t.timestamps
    end
  end
end
