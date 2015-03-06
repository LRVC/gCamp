require 'rails_helper'

feature 'User can log in and out' do
  scenario 'sign up link is visible on index and user can sign up after clicking link' do
    visit root_path

    expect(page).to have_content 'Sign Up'

    click_link 'Sign Up'
    expect(current_path).to eq sign_up_path

    fill_in :user_first_name, with: 'John'
    fill_in :user_last_name, with: 'Denver'
    fill_in :user_email, with: 'JohnDenver@email.test'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    click_button 'Sign Up'

    expect(page).to have_content 'John Denver'
  end

  scenario 'User can sign in with valid data' do
    person = User.create(first_name: 'John',last_name: 'Denver', email: 'john@denver.com', password: 'password')
    visit sign_in_path

    fill_in :email, with: 'john@denver.com'
    fill_in :password, with: 'password'
    click_button 'Sign In'

    expect(current_path).to eq root_path
    expect(page).to have_content 'John Denver'
  end

  scenario 'User can log out' do
    sign_in_user

    click_link 'Sign Out'

    expect(page).to have_content 'Sign In'
  end

end
