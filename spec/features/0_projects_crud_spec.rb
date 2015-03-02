require 'rails_helper'

feature 'Projects CRUD' do
  scenario 'Users can see project names from index page and create new users from link' do
    errands = Project.new(name: "Errands")
    errands.save!

    visit projects_path

    expect(page).to have_content "Projects"
    expect(page).to have_content "Errands"

    click_link "New Project"

    expect(current_path).to eq new_project_path

    expect(page).to have_content "New Project"

    fill_in :project_name, with: "Errands"
    click_button "Create Project"

    expect(page).to have_content "Project was created successfully"
  end

  scenario 'User can edit project' do
    errands = Project.new(name: "Errands")
    errands.save!

    visit edit_project_path(errands)

    expect(page).to have_content "Edit Project"
    fill_in :project_name, with: "Do something"
    click_button "Update Project"

    expect(page).to have_content "Project was updated successfully"
  end

  scenario 'Validates that fields are not blank when creating new user' do
    visit new_project_path

    click_button "Create Project"
    expect(page).to have_content "1 error prohibited this form from being saved:"
  end
end
