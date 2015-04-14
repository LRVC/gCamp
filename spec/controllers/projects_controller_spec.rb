require 'rails_helper'

describe ProjectsController do
  describe 'GET #index' do
    it 'assigns all projects' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

      get :index

      expect(assigns(:projects)).to eq [project]
    end
  end

  describe 'GET #new' do
    it 'assigns a new project' do
      User.destroy_all
      Project.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')

      get :new

      expect(assigns(:project)).to be_a_new(Project)
    end
  end

  describe 'POST #create' do
    describe 'on success' do
      it 'creates a new project with valid data' do
        User.destroy_all
        Project.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id

        expect {
           post :create, project: { name: 'Sunshine' }
         }.to change { Project.all.count }.by(1)

        project = Project.last
        expect(project.name).to eq "Sunshine"
        expect(flash[:notice]).to eq "Project was created successfully"
        expect(response).to redirect_to project_tasks_path(project)
      end
    end

    describe 'on failure' do
      it 'does not create a new project with invalid data' do
        User.destroy_all
        Project.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id

        expect {
          post :create, project: { name: nil }
        }.to_not change { Project.all.count }

        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    describe 'on success' do
      it 'updates a project with valid data and correct authorization' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

        expect {
          patch :update, id: project.id, project: { name: 'Moonlight' }
        }.to change { project.reload.name }.from("Sunshine").to("Moonlight")

        expect(project.name).to eq "Moonlight"
        expect(flash[:notice]).to eq "Project was updated successfully"
        expect(response).to redirect_to project_path(project)
      end
    end

    describe 'on failure' do
      it 'does not let a user update without valid params' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

        expect {
          patch :update, id: project.id, project: { name: nil }
        }.to_not change { project.reload.name }

        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it 'deletes a project' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

      expect {
        delete :destroy, id: project.id
      }.to change { Project.all.count }.by(-1)

      expect(flash[:notice]).to eq "Project was deleted successfully"
      expect(response).to redirect_to projects_path
    end
  end

end
