require 'rails_helper'

feature 'Users CRUD tasks' do

  scenario 'user can see all users first, last, and email from index page' do
    john = User.create(first_name: 'John', last_name: 'Doe', email: 'johndoe@john.john')
    john.save!
    ben = User.create(first_name: 'Ben', last_name: 'Benjamin', email: 'ben@ben.ben')
    ben.save!
    visit '/users'

    expect(current_path).to eq users_path

    expect(page).to have_content 'Users'
    expect(page).to have_content 'John Doe'
    expect(page).to have_content 'johndoe@john.john'
    expect(page).to have_content 'Ben Benjamin'
    expect(page).to have_content 'ben@ben.ben'

    expect(page).to have_link 'Edit'
    expect(page).to have_link 'New User'
  end

  scenario 'can create new user from the new user form' do
    visit '/users/new'

    expect(current_path).to eq new_user_path

    fill_in :user_first_name, with: "Bob"
    fill_in :user_last_name, with: "Dole"
    fill_in :user_email, with: "test@example.com"
    click_button 'Create User'

    expect(current_path).to eq users_path

    expect(page).to have_content 'Bob Dole'
    expect(page).to have_content 'test@example.com'

    expect(current_path).to eq users_path
    expect(page).to have_content 'User was successfully created'
  end

  scenario 'can edit and update from edit form' do
    john = User.create(first_name: 'John', last_name: 'Doe', email: 'johndoe@john.john')
    john.save!
    visit edit_user_path(john)

    expect(page).to have_content 'Update User'
    fill_in :user_first_name, with: "Bob"
    fill_in :user_last_name, with: "Dole"
    fill_in :user_email, with: "test@example.com"
    click_button 'Update User'

    expect(current_path).to eq users_path
    expect(page).to have_content 'User was successfully updated'
  end

  scenario 'errors display when new user fields are blank' do
    visit '/users/new'

    expect(page).to have_content 'New User'
    fill_in :user_first_name, with: ""
    fill_in :user_last_name, with: ""
    fill_in :user_email, with: ""

    expect(current_path).to eq new_user_path

  end

end
