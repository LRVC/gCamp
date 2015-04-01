require 'rails_helper'

feature 'Tasks CRUD' do

  before :each do
    User.destroy_all
    user = User.new(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
    user.save!
    visit root_path
    click_link 'Sign In'
    fill_in :email, with: 'bob@dole.com'
    fill_in :password, with: 'bob'
    click_button 'Sign In'
    project = Project.create!(name: 'Sunshine')
    Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
    task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

  end


  scenario 'Users can create new task' do

    visit projects_path
    expect(page).to have_content 'Tasks'
    expect(page).to have_content 'Sunshine'

    within('.table') { click_link 'Sunshine' }
    expect(page).to have_content '1 task'
    click_link '1 task'

    click_link 'New Task'
    expect(page).to have_content "New Task"
    fill_in :task_description, with: "Anything you want"
    fill_in :task_due_date, with: "02/03/2015"
    click_button 'Create Task'

    expect(page).to have_content "Anything you want"
  end

  scenario 'User can edit tasks' do
    visit projects_path
    expect(page).to have_content 'Sunshine'

    within('.table') { click_link 'Sunshine' }
    expect(page).to have_content '1 task'
    click_link '1 task'

    click_link 'New Task'
    expect(page).to have_content "New Task"
    fill_in :task_description, with: "Anything you want"
    fill_in :task_due_date, with: "02/03/2015"
    click_button 'Create Task'

    within('.table') { click_on 'Anything you want' }

    click_on 'Edit'
    fill_in :task_description, with: "run errrands"
    fill_in :task_due_date, with: "02/04/2015"
    click_button 'Update Task'

    expect(page).to have_content "Task was successfully updated"
  end

  scenario 'display error messages and validate task fields' do

    visit projects_path
    expect(page).to have_content 'Tasks'
    expect(page).to have_content 'Sunshine'

    within('.table') { click_link 'Sunshine' }
    expect(page).to have_content '1 task'
    click_link '1 task'

    click_link 'New Task'

    click_button 'Create Task'
    expect(page).to have_content "1 error prohibited this form from being saved:"
  end
end
