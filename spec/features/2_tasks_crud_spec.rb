require 'rails_helper'

feature 'Tasks CRUD' do
  xscenario 'Users can see tasks list with description and due date and create new task' do
    sign_in_user
    errand = Task.new(description: "errands", due_date: Date.today)
    errand.save!

    visit project_tasks_path
    expect(page).to have_content "errands"
    expect(page).to have_content Date.today.strftime("%m/%d/%y")

    click_link 'New Task'

    expect(page).to have_content "New Task"
      fill_in :task_description, with: "Anything you want"
    fill_in :task_due_date, with: "02/03/2015"
    click_button 'Create Task'
  end

  xscenario 'User can edit tasks' do
    sign_in_user
    errand = Task.new(description: "errands", due_date: Date.today)
    errand.save!

    visit edit_task_path(errand)

    fill_in :task_description, with: "run errrands"
    fill_in :task_due_date, with: "02/04/2015"
    click_button 'Update Task'

    expect(page).to have_content "Task was successfully updated"
  end

  xscenario 'display error messages and validate task fields' do
    sign_in_user
    visit new_task_path

    click_button 'Create Task'
    expect(page).to have_content "1 error prohibited this form from being saved:"
  end
end
