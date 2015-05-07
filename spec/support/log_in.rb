  def log_in
    visit "/"
    expect(page).to have_content("Log In")
    fill_in "Email Address", with: user.email
    fill_in "Password", with: user.password
    click_button "log-in"
    expect(page).to have_content("Thanks for logging in!")
  end