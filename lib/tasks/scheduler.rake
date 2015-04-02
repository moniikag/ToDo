desc "This task is called by the Heroku scheduler add-on"

#task :remind => :environment do
#  TodoList.send_reminder
#end

task :remind => :environment do
	@todo_list = TodoList.find(params[:id])
	    @todo_lists = TodoList.all
	    @urgent_items = []
	    @todo_lists.each do |todo_list|
	      todo_list.todo_items.all.each do |todo_item|
	        if (todo_item.deadline.to_time - Time.now - 25.hours) < 0
	          @urgent_items << todo_item
	        end
	      end
	    end
	 UserMailer.reminder(@urgent_items).deliver
 end