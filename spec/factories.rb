FactoryGirl.define do

  factory :unconfirmed_user, class: User do |u|
    u.sequence(:email) { |n| "#{n}factory@example.com" }
    u.password "password"
    u.password_confirmation "password"
  end

  factory :user, parent: :unconfirmed_user do |u|
    after(:create) { |user| user.update_attribute('activation_token', nil) }
  end

  factory :todo_list do |l|
    l.sequence(:title) { |n| "Factory#{n}TodoList " }
    l.sequence(:description) { |n| "Factory#{n}TodoListDescription " }
    user
  end

  factory :todo_item do |i|
    i.sequence(:content) { |n| "#{n} Todo Item" }
    deadline "2016-08-30 10:00:00"
    todo_list
  end

  factory :tag, class: ActsAsTaggableOn::Tag do |t|
    t.sequence(:name) { |n| "Tag #{n}"}
  end

  factory :tagging, class: ActsAsTaggableOn::Tagging do |t|
    tag_id {}
    taggable_id {}
    taggable_type {}
    context "tags"
  end

  factory :invitation, class: Invitation do
    todo_list
  end

  factory :invitation_with_email, parent: :invitation do |inv|
    before(:create) do |inv|
      user = FactoryGirl.create(:unconfirmed_user)
      inv.invited_user_email = user.email
    end
  end

end
