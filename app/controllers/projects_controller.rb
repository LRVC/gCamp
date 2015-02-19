class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(projects_params)
    if @project.save
      redirect_to projects_path, notice: "Project was created successfully"
    else
      render :new
    end
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def projects_params
    params.require(:project).permit(:name)
  end
end
