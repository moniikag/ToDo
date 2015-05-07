FactoryGirl.define do
  factory :user do
    email "factory@example.com"
    password "password"
    password_confirmation "password"
  end

  factory :todo_list do
    title "FactoryTodoList "
    description "FactoryTodoListDescription "
    user
  end

  factory :todo_item do
    content "Todo Item"
    deadline "2015-05-30 10:00:00"
    todo_list
  end
end