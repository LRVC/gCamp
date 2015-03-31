require 'rails_helper'

feature 'Users CRUD tasks' do

  before :each do
    User.destroy_all
    @user = User.new(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
    @user.save!
    visit root_path
    click_link 'Sign In'
    fill_in :email, with: 'bob@dole.com'
    fill_in :password, with: 'bob'
    click_button 'Sign In'
  end

  scenario 'user can see all users from index page' do
    visit users_path

    expect(current_path).to eq users_path

    expect(page).to have_content 'Users'
    expect(page).to have_content 'Bob Dole'

    expect(page).to have_link 'New User'
  end

  scenario 'can create new user from the new user form' do

    visit new_user_path

    fill_in :user_first_name, with: 'Bob'
    fill_in :user_last_name, with: 'Builder'
    fill_in :user_email, with: 'builder@email.test'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    click_button 'Create User'

    expect(current_path).to eq users_path

    expect(page).to have_content 'Bob Builder'
    expect(page).to have_content 'User was successfully created'
  end

  scenario 'can edit and update from edit form' do

    visit edit_user_path(@user)

    expect(page).to have_content 'Update User'
    fill_in :user_first_name, with: "Bob"
    fill_in :user_last_name, with: "Dole"
    fill_in :user_email, with: "test@example.com"
    fill_in :user_password, with: "pass"
    fill_in :user_password_confirmation, with: "pass"
    click_button 'Update User'

    expect(current_path).to eq users_path
    expect(page).to have_content 'User was successfully updated'
  end

  scenario 'errors display when new user fields are blank' do

    visit new_user_path

    expect(page).to have_content 'New User'
    click_button 'Create User'
    expect(page).to have_content 'Password can\'t be blank'

    expect(current_path).to eq users_path

  end

end
