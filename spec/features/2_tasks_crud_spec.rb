require 'rails_helper'

feature 'Tasks CRUD' do
  scenario 'Users can see tasks list with description and due date and create new task' do
    sign_in_user
    project = Project.new(name: 'Silly project')
    project.save!
    errand = Task.new(description: "errands", due_date: Date.today)
    errand.save!

    visit projects_path
    expect(page).to have_content 'Tasks'
    expect(page).to have_content 'Silly project'

    click_link 'Silly project'
    expect(page).to have_content '0 tasks'
    click_link '0 tasks'

    click_link 'New Task'
    expect(page).to have_content "New Task"
    fill_in :task_description, with: "Anything you want"
    fill_in :task_due_date, with: "02/03/2015"
    click_button 'Create Task'

    expect(page).to have_content "Anything you want"
  end

  scenario 'User can edit tasks' do
    sign_in_user
    project = Project.new(name: 'Silly project')
    project.save!
    errand = Task.new(description: "errands", due_date: Date.today)
    errand.save!

    visit projects_path
    expect(page).to have_content 'Silly project'

    click_link 'Silly project'
    expect(page).to have_content '0 tasks'
    click_link '0 tasks'

    click_link 'New Task'
    expect(page).to have_content "New Task"
    fill_in :task_description, with: "Anything you want"
    fill_in :task_due_date, with: "02/03/2015"
    click_button 'Create Task'

    click_link 'Edit'

    expect(page).to have_content "Edit Task"
    fill_in :task_description, with: "run errrands"
    fill_in :task_due_date, with: "02/04/2015"
    click_button 'Update Task'

    expect(page).to have_content "Task was successfully updated"
  end

  scenario 'display error messages and validate task fields' do
    sign_in_user
    project = Project.new(name: 'Silly project')
    project.save!
    errand = Task.new(description: "errands", due_date: Date.today)
    errand.save!

    visit projects_path
    expect(page).to have_content 'Tasks'
    expect(page).to have_content 'Silly project'

    click_link 'Silly project'
    expect(page).to have_content '0 tasks'
    click_link '0 tasks'

    click_link 'New Task'

    click_button 'Create Task'
    expect(page).to have_content "2 errors prohibited this form from being saved:"
  end
end
