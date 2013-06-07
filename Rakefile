# Rakefile
require "./app"
require "sinatra/activerecord/rake"

task :input_reminder do
	 user_list = User.all.to_a
	 user_list.each do |user| 
	 	post_list = Post.where(:phone => user.phone)
	 	if post_list.where(:date_created => Time.now.to_date) == nil
	 		message = client.account.sms.messages.create(:from => '+13479604306', :to => user.phone, :body => 'Reminder! Please input your weight!')
			puts message
	  	end
	  end
	 puts "Did the reminder task" 			
end