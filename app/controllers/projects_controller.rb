class ProjectsController < ApplicationController
  before_action :check_current_user
  before_action :find_project, only: [:show, :edit, :update, :destroy]
  before_action :check_member, only: [:show, :edit, :update, :destroy]
  before_action :find_member, only: [:edit, :update, :destroy]


  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(projects_params)
    if @project.save
      @project.memberships.create(user_id: current_user.id, role: "Owner")
      redirect_to project_tasks_path(@project), notice: "Project was created successfully"
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update
    if @project.update(projects_params)
      redirect_to project_path(@project), notice: "Project was updated successfully"
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      redirect_to projects_path, notice: "Project was deleted successfully"
    end
  end

  private

  def projects_params
    params.require(:project).permit(:name)
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def check_current_user
    if current_user
      @user = current_user
    else
      session[:redirect_to] = request.fullpath
      redirect_to sign_in_path, alert: "You must sign in"
    end
  end

  def check_member
    @current_membership = current_user.memberships.find_by(project_id: @project.id)
    if !(current_user.memberships.find_by(project_id: @project.id) == nil) || current_user.admin

    else
      flash[:alert] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end

  def find_member
    if !(current_user.admin)
      @current_membership = current_user.memberships.find_by(project_id: @project.id)
      if @current_membership.role == "Owner"

      else
        flash[:alert] = 'You do not have access'
        render :show
      end
    end
  end

end
