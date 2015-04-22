require 'spec_helper'

describe 'Tags: ' do

	let!(:user) { User.create!(first_name: "example", last_name: "example", email: "example@example.com", password: "password", password_confirmation: "password") }
	let!(:todo_list) { user.todo_lists.create!(title: "Groceries", description: "Grocery list") }
	let!(:todo_item) { todo_list.todo_items.create!(content: "Potato", deadline: Time.now) }


	def log_in
		visit "/user_sessions/new"
		fill_in "email", with: "example@example.com"
		fill_in "password", with: "password" 
		click_button "Log In"
    expect(response.status).to eq(200)
    expect(page).to have_content("Thanks for logging in!")
	end

	it "saves properly tags given with ', '" do
		log_in
		visit "/todo_lists/#{todo_list.id}/todo_items/new"

		fill_in "Content", with: "Task one"
		fill_in "Tag list", with: "important, urgent"
		click_button "Save"

		expect(Tag.count).to eq(2)
		expect(Tag.where("name = 'important'")).to_not eq([])
		expect(Tag.where("name = 'urgent'")).to_not eq([])
		expect(Tag.where("name = 'joke'")).to eq([])

	end

	it "saves properly tags given with ','" do
		log_in
		visit "/todo_lists/#{todo_list.id}/todo_items/new"

		fill_in "Content", with: "Task one"
		fill_in "Tag list", with: "important,urgent"
		click_button "Save"

		expect(Tag.count).to eq(2)
		expect(Tag.where("name = 'important'")).to_not eq([])
		expect(Tag.where("name = 'urgent'")).to_not eq([])
		expect(Tag.where("name = 'joke'")).to eq([])
	end

	it "saves properly tags given with ' ,'" do
		log_in
		visit "/todo_lists/#{todo_list.id}/todo_items/new"

		fill_in "Content", with: "Task one"
		fill_in "Tag list", with: "important,urgent"
		click_button "Save"

		expect(Tag.count).to eq(2)
		expect(Tag.where("name = 'important'")).to_not eq([])
		expect(Tag.where("name = 'urgent'")).to_not eq([])
		expect(Tag.where("name = 'joke'")).to eq([])
	end

	it "saves properly tags given with ' , '" do
		log_in
		visit "/todo_lists/#{todo_list.id}/todo_items/new"

		fill_in "Content", with: "Task one"
		fill_in "Tag list", with: "important , urgent"
		click_button "Save"

		expect(Tag.count).to eq(2)
		expect(Tag.where("name = 'important'")).to_not eq([])
		expect(Tag.where("name = 'urgent'")).to_not eq([])
		expect(Tag.where("name = 'joke'")).to eq([])
	end

	it "saves properly tags consisting from few words" do
		log_in
		visit "/todo_lists/#{todo_list.id}/todo_items/new"

		fill_in "Content", with: "Task one"
		fill_in "Tag list", with: "impo rtant, urgent"
		click_button "Save"

		expect(Tag.count).to eq(2)
		expect(Tag.where("name = 'impo rtant'")).to_not eq([])
		expect(Tag.where("name = 'urgent'")).to_not eq([])
		expect(Tag.where("name = 'joke'")).to eq([])
	end

end


