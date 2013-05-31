class CreatePosts < ActiveRecord::Migration
 def up
  	create_table :posts do |t|
      t.string :phone
      t.float :weight
      t.boolean :work_out
      t.boolean	:good_day
      t.timestamps
    end
  end
  def down
  	drop_table :posts
  end
end
