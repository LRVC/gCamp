require 'rails_helper'
describe MembershipsController do
  describe 'GET #index' do
    it 'redirects a user if they are not logged in' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      project = Project.create!(name: 'Sunshine')
      Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

      get :index, project_id: project.id

      expect(response).to redirect_to sign_in_path
      expect(flash[:alert]).to eq "You must sign in"
    end
  end

  describe 'POST #create' do
    describe 'on success' do
      it 'creates a new membership with valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')
        full_name = user.first_name.capitalize + " " + user.last_name.capitalize

        expect {
          post :create, project_id: project.id, membership: {project_id: project.id, user_id: user.id, role: 'Owner'}
        }.to change { Membership.all.count }.by(1)

        membership = Membership.last
        expect(membership.role).to eq "Owner"
        expect(flash[:notice]).to eq "#{ membership.user.full_name } was added successfully"
        expect(response).to redirect_to project_memberships_path(project)
      end
    end

    describe 'on failure' do
      it 'does not create a new membership without valid params' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
        session[:user_id] = user.id
        project = Project.create!(name: 'Sunshine')

        expect {
          post :create, project_id: project.id, user_id: user.id, membership: {role: nil}
        }.to_not change { Membership.all.count }
      end
    end
  end

    describe 'PATCH #update' do
      describe 'when a user is a member of the project' do
        it 'updates a membership when given valid params' do
          User.destroy_all
          user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
          project = Project.create!(name: 'Sunshine')
          membership = Membership.create!(user_id: user.id, project_id: project.id, role: 'Owner')

          user2 = User.create!(first_name: 'Bob', last_name: 'Ross', email: 'bob@ross.com', password: 'bob', admin: false)
          project2 = Project.create!(name: 'Sunshine')
          membership = Membership.create!(user_id: user2.id, project_id: project2.id, role: 'Owner')


          expect {
            patch :update, project_id: project.id, id: membership.id, membership: {
              role: 'Member'
            }
          }.to change { membership.reload.role }.from('Owner').to('Member')
        end
      end


    end


end
