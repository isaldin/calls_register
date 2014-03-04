class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics do |t|
      t.date :day
      t.integer :duration
      t.integer :count
      t.integer :user_id

      t.timestamps
    end
  end
end
