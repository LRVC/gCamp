require 'rails_helper'

feature 'Projects CRUD' do

  before :each do
    user = User.new(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
    user.save!
    visit root_path
    click_link 'Sign In'
    fill_in :email, with: 'bob@dole.com'
    fill_in :password, with: 'bob'
    click_button 'Sign In'
    project = Project.create!(name: 'Sunshine')
    Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
  end

  scenario 'Users can make a new project' do
    visit new_project_path
    expect(page).to have_content "New Project"

    fill_in :project_name, with: "Sunshine"
    click_button "Create Project"

    expect(page).to have_content "Project was created successfully"
  end

  scenario 'User can edit a project' do
    visit projects_path
    within('.table'){ click_on 'Sunshine' }

    click_link 'Edit'
    fill_in :project_name, with: "Moonlight"
    click_button "Update Project"

    expect(page).to have_content "Project was updated successfully"
  end

  scenario 'Validates that fields are not blank when creating new user' do
    visit new_project_path

    click_button "Create Project"
    expect(page).to have_content "1 error prohibited this form from being saved:"
  end
end
