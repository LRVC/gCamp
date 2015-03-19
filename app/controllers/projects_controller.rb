class ProjectsController < ApplicationController
  before_action :check_current_user

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
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(projects_params)
      redirect_to project_path(@project), notice: "Project was updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      redirect_to projects_path, notice: "Project was deleted successfully"
    end
  end

  private

  def projects_params
    params.require(:project).permit(:name)
  end

  def check_current_user
    if current_user

    else
      redirect_to sign_in_path, notice: "You must sign in"
    end
  end
end
