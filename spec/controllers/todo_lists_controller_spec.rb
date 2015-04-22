require 'spec_helper'

describe 'Displaying todo_list' do

	# def register(options={})
	# 	options[:name]||="Name"
	# 	options[:surname]||="surname"
	# 	options[:email]||="example@example.com"
	# 	options[:password]||="password"

	# 	visit "/users/new"
	# 	fill_in "First Name", with: options[:name]
	# 	fill_in "Last Name", with: options[:surname]
	# 	fill_in "Email", with: options[:email]
	# 	fill_in "Password", with: options[:password]
	# 	fill_in "Password (again)", with: options[:password]
	# 	click_button "Sign Up"
	# end

	# def create_todo_list(options={})
	# 	options[:title]||="TodoList"
	# 	options[:description]||="Description"

	# 	visit "/todo_lists/new"
	# 	fill_in "Title", with: options[:title]
	# 	fill_in "Description", with: options[:description]
	# 	click_button "Create Todo list"
	# end
	let(:user) { User.create(first_name: "example", last_name: "example", email: "example@example.com", password_digest: "password") }
	let(:todo_list) { TodoList.create(title: "Groceries", description: "Grocery list", user_id: User.where("first_name = 'example'").id) }
	let(:todo_list) { TodoList.create(title: "Fruits", description: "Fruits list") }

	def log_in
		visit "/user_sessions/new"
		fill_in "Email Address", with: "example@example.com"
		fill_in "Password", with: "password"
	end

	it 'displays todo list for current_user' do
		log_in
		visit "/todo_lists"
		expect(page).to have_content("Groceries")
		expect(response.status).to eq(200)
	end

	it "does not display todo lists that doesn't belong to current_user" do
		log_in
		visit "/todo_lists"
		expect(page).to_not have_content("Fruits")
	end

	it "does not allow user enter todo list that doesn't belog to him" do |variable|
		log_in
		visit "/todo_lists/#{TodoList.last.id}"
		expect(page).to_not have_content("Fruits")
		expect(response.status).to eq(404)
	end



end











