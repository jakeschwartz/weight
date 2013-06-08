# app.rb
require "sinatra"
require "sinatra/activerecord"
require "twilio-ruby"
require "sinatra/graph"

$stdout.sync = true

account_sid = 'AC215e00c06a154432a2d22fcf97914084'
auth_token = 'd94b7056f2c9d3ad00bd462916880b2a'

# set up a client to talk to the Twilio REST API
@client = Twilio::REST::Client.new account_sid, auth_token

configure :development, :test do
  set :database, 'sqlite3:///blog.db'
end

 
configure :production do
  # Database connection
  db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')  
  
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
 
class App < Sinatra::Base
	register Sinatra::Graph
end

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
	w.weight = params[:weight].to_f
	w.phone = dude.phone
	w.created_at = Time.now
	w.updated_at = Time.now
	w.save
	redirect '/'
end

	
get "/createuser" do
	erb :"/create_user"
end


	
get "/showusers" do
	data = User.all
	@users = data.to_a
	puts @users
	erb :"/users"
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
	
get "/graph" do
	graph "First Graph", :prefix => '/graphs' do
		bar "Sales", [5, 2, 6, 2, 1]
	end
	erb :"/graph"
end
	
	
post "/sms" do
	if params[:Body].to_f > 50
		phone = params[:From]
		dude = User.find_by_phone(phone)
		name = dude.first_name
		weight = params[:Body].to_f
		puts phone
		puts weight
		w = Post.new
		w.weight = weight
		w.phone = phone
		w.date_created = Time.now.to_date
		w.created_at = Time.now
		w.updated_at = Time.now
		yesterday = Post.where(:phone => phone, :date_created => Time.now.to_date - 1)
		if yesterday[0].weight != nil
			y = yesterday[0].weight
			diff = (weight - y).round(1)
		else 
			diff = 1000
		end
		if diff <= 0
			diff_word = "lost"
			diff = diff * -1
		else
			diff_word = "gained"
		end
		w.save
		twiml = Twilio::TwiML::Response.new do |r|
	    	r.Sms "Thanks #{name}! We logged the weigh-in at #{weight}. You #{diff_word} #{diff} pounds.  Did you work out yesterday (yes/no)?"
	  	end
	  twiml.text
	elsif params[:Body] == "yes" || params[:Body] == "no" || params[:Body] == "Yes" || params[:Body] == "No"
	 	phone = params[:From]
		dude = User.find_by_phone(phone)
		name = dude.first_name
		if params[:Body] == "yes" || params[:Body] == "Yes"
			work_out = true
		else
			work_out = false
		end
		w = Post.last
		w.work_out = work_out
		w.save
		puts w.work_out
		twiml = Twilio::TwiML::Response.new do |r|
	    	r.Sms "Thanks! Have a great day!"
		end
		twiml.text
	else
	  	twiml = Twilio::TwiML::Response.new do |r|
	    	r.Sms "Sorry - I'm not sophisticated enough to understand your text."
		end
		twiml.text
	end 	
end

	

