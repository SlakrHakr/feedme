class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.references :article, foreign_key: true
      t.references :user, foreign_key: true
      t.string :key, null: false
      t.string :value, null: false

      t.timestamps
    end
  end
end
