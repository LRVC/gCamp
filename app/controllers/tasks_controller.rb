class TasksController < ApplicationController

  before_action :check_current_user
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :check_member, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = @project.tasks
  end

  def new
    @task = Task.new
  end

  def create
    @task = @project.tasks.new(tasks_params)
     if @task.save
       redirect_to project_tasks_path(@project, @task), notice: 'Task was successfully created.'
     else
       render :new
     end

  end

  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
    @comments = Comment.all
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if  @task.update(tasks_params)
        redirect_to project_task_path, notice: 'Task was successfully updated'
    else
        render :edit
    end

  end

  def destroy
    task = @project.tasks.find(params[:id])
    task.destroy
    redirect_to project_tasks_path(@project), notice: "Task was successfully deleted."
  end

  private

  def tasks_params
    params.require(:task).permit(:description, :completed, :due_date)
  end

  def check_current_user
    if current_user
      @user = current_user
    else
      redirect_to sign_in_path
      flash[:alert] = "You must sign in"
    end
  end

  def check_member
    if current_user.memberships.find_by(project_id: @project.id) == nil
      flash[:alert] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end
end
