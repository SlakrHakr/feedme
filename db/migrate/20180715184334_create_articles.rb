class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.references :feed, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false
      t.datetime :published_date
      t.string :description

      t.timestamps
    end
  end
end
