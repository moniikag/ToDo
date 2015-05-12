FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) { |n| "#{n}factory@example.com" }
    u.sequence(:password) { |n| "#{n}password" }
    u.sequence(:password_confirmation) { |n| "#{n}password" }
    u.email_confirmed true
  end

  factory :todo_list do |l|
    l.sequence(:title) { |n| "Factory#{n}TodoList " }
    l.sequence(:description) { |n| "Factory#{n}TodoListDescription " }
    user
  end

  factory :todo_item do |i|
    i.sequence(:content) { |n| "#{n} Todo Item" }
    deadline "2015-05-30 10:00:00"
    todo_list
  end

  factory :tag do |t|
    t.sequence(:name) { |n| "Tag #{n}"}
  end

end