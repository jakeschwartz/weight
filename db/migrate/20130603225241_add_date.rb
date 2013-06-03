class AddDate < ActiveRecord::Migration
  def up
  	add_column :posts, :date_created, :date
  end

  def down
  	remove_column :posts
  end
end
