require 'spec_helper' 

describe 'Loggin Out' do
  let!(:user) { FactoryGirl.create(:user) }
  
  it "allows user to log out" do
    user.update_attribute('activation_token', nil)
    log_in
    click_link "log-out-link"
    expect(page).to have_content("Log In")
    expect(page).to have_content("You have successfully logged out")  
    expect(current_path).to eq(new_user_sessions_path)
  end

end