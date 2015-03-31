require 'rails_helper'

describe TasksController do
  describe 'GET #index' do
    it 'assigns tasks' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
      task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

      get :index, project_id: project.id

      expect(assigns(:tasks)).to eq [task]
    end
  end

  describe 'GET #new' do
    it 'assigns a new task' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
      task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

      get :new, project_id: project.id

      expect(assigns(:task)).to be_a_new(Task)
    end
  end

  describe 'POST #create' do
    describe 'on success' do
      it 'creates a new task when given valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

        expect {
          post :create, project_id: project.id, task: {
            description: "Finish this project", due_date: '2015-04-02'
          }
        }.to change { Task.all.count }.by(1)

        task = Task.last
        expect(task.description).to eq "Finish this project"
        expect(flash[:notice]).to eq "Task was successfully created."
        expect(response).to redirect_to project_tasks_path(project, task)
      end
    end

    describe 'on failure' do
      it 'does not create a new task without valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

        expect {
          post :create, project_id: project.id, task: {
            description: nil, due_date: '2015-04-02'
          }
        }.to_not change { Task.all.count }

        expect(response).to render_template :new
      end
    end
  end

  describe 'GET #show' do
    it 'shows an instance of a task' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
      task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

      get :show, project_id: project.id, id: task.id
    end
  end

  describe 'PATCH #update' do
    describe 'on success' do
      it 'allows a task to be updated with valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
        task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

        expect {
          patch :update, project_id: project.id, id: task.id, task: { description: "Finish that project", due_date: '2015-04-02' }
        }.to change { task.reload.description }.from("Finish this project").to("Finish that project")

        expect(flash[:notice]).to eq "Task was successfully updated"
        expect(response).to redirect_to project_task_path(project, task)
      end
    end

    describe 'on failure' do
      it 'does not allow a task to be updated without valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
        task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

        expect {
          patch :update, project_id: project.id, id: task.id, task: {
            description: nil, due_date: '2015-04-02'
          }
        }.to_not change { task.reload.description }

        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a task' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')
      task = project.tasks.create(description: "Finish this project", due_date: '2015-04-02')

      expect {
        delete :destroy, project_id: project.id, id: task.id
      }.to change { Task.all.count }.by(-1)

      expect(response).to redirect_to project_tasks_path(project)
    end
  end
end
