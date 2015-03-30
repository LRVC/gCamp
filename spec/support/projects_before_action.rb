def projects_before_action
  user = User.new(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob')
  user.save!
  visit root_path
  click_link 'Sign In'
  fill_in :email, with: 'bob@dole.com'
  fill_in :password, with: 'bob'
  click_button 'Sign In'
  project = Project.create!(name: 'Sunshine')
  Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
end
