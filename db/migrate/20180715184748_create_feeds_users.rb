class CreateFeedsUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :feeds_users, id: false do |t|
      t.belongs_to :feed, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
