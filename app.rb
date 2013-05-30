# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:///blog.db"

class Post < ActiveRecord::Base
end

class User < ActiveRecord::Base
end

get "/" do
  	@posts = Post.order("created_at DESC")
  	erb :"/index"
end

post "/" do
	w = Post.new
	w.weight = params[:weight]
	w.phone = 5555555555
	w.created_at = Time.now
	w.updated_at = Time.now
	w.save
	redirect '/'
end
	
get "/createuser" do
	erb :"/create_user"
end

post "/createuser" do
	t = Time.now
	u = User.new
	u.first_name = params[:first_name]
	u.last_name = params[:last_name]
	u.phone = params[:phone]
	u.created_at = t
	u.updated_at = t
	u.save
	redirect '/'
end
	

def test_function(a,b)
	puts a * b
	Post.create(weight:a,phone:b)
end

