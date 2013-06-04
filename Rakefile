# Rakefile
require "./app"
require "sinatra/activerecord/rake"

task :input_reminder do
	 user_list = User.all.to_a
	 user_list.each do |user| 
	 	post_list = Post.where(:phone => user.phone)
	 	if post_list.where(:date_created => Time.now.to_date) == nil
	 		twiml = Twilio::TwiML::Response.new do |r|
	    		r.Sms "We haven't talked today! What did you weigh in at?"
	  		end
	  	end
	  end
	 puts "Did the reminder task" 			
end