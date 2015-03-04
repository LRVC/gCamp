def sign_in_user
  user = User.new(first_name: 'Steve', last_name: 'themonkey', email: 'steve@monkey.com', password: 'steve')
  user.save!
  visit root_path
  click_link 'Sign In'
  fill_in :email, with: 'steve@monkey.com'
  fill_in :password, with: 'steve'
  click_button 'Sign In'
end
