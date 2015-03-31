require 'rails_helper'

describe UsersController do
  describe "GET #index" do
    it 'Assigns all users with the name of Bob Dole' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false)
      session[:user_id] = user.id

      get :index
      expect(assigns(:users)).to eq [user]
    end
  end

  describe "GET #new" do
    it 'assigns a new user' do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob')
      session[:user_id] = user.id

      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end
  describe "POST #create" do
    describe "on success" do
      it "creates a new user with valid parameters" do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
        session[:user_id] = user.id

        expect {
          post :create, user: { first_name: 'Bob', last_name: 'Dole', email: 'bob2@dole.com', password: 'bob', admin: true }
        }.to change {User.all.count }.by(1)

        user = User.last
        expect(user.first_name).to eq "Bob"
        expect(user.last_name).to eq "Dole"
        expect(user.email).to eq "bob2@dole.com"
        expect(flash[:notice]).to eq "User was successfully created."
      end
    end

    describe "on failure" do
      it "does not create a book with invalid parameters" do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob')
        session[:user_id] = user.id

        expect {
          post :create, user: { first_name: nil, last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: false }
        }.to_not change { User.all.count }

        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    describe "on success" do
      it 'updates a user with valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
        session[:user_id] = user.id

        expect {
          patch :update, id: user.id, user: { first_name: 'John', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true }
        }.to change { user.reload.first_name }.from("Bob").to("John")

        user = User.last
        expect(user.first_name).to eq "John"
        expect(user.last_name).to eq "Dole"
        expect(user.email).to eq "bob@dole.com"
        expect(flash[:notice]).to eq "User was successfully updated"
        expect(response).to redirect_to users_path
      end
    end

    describe "on failure" do
      it 'does not update a user without valid parameters' do
        User.destroy_all
        user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
        session[:user_id] = user.id

        expect {
          patch :update, id: user.id, user: { first_name: nil, last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true }
        }.to_not change { user.reload.first_name }

        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes a user" do
      User.destroy_all
      user = User.create!(first_name: 'Bob', last_name: 'Dole', email: 'bob@dole.com', password: 'bob', admin: true)
      session[:user_id] = user.id

      expect {
        delete :destroy, id: user.id
      }.to change { User.all.count }.by(-1)

      expect(flash[:notice]).to eq "User was successfully deleted"
      expect(response).to redirect_to users_path
    end
  end
end
