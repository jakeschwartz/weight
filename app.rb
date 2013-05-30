# app.rb
require "sinatra"
require "sinatra/activerecord"

set :database, "sqlite3:///blog.db"

class Post < ActiveRecord::Base
	belongs_to :user
end

class User < ActiveRecord::Base
	has_many :posts
end

get "/" do
  	erb :"/index"
end

post "/" do
	dude = User.find_by_phone(params[:phone])
	puts dude.id
	w = Post.new
	w.weight = params[:weight]
	w.phone = dude.phone
	w.created_at = Time.now
	w.updated_at = Time.now
	w.save
	redirect '/'
end
	
get "/createuser" do
	erb :"/create_user"
end

get "/user/:id/weights" do
	userphone = User.find(params[:id]).phone
	@person = User.find(params[:id]).first_name
	@weights = Post.where(:phone => userphone).to_a
	print @weights
	erb :"/weights"
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

