class TasksController<ApplicationController

  def index
    @task = Task.all
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(tasks_params)
     if @task.save
       redirect_to task_path(@task), notice: 'Task was successfully created.'
     else
       render :new
     end

  end

  def show

    @task = Task.find(params[:id])

  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if  @task.update(tasks_params)
        redirect_to task_path
    else
        render :edit
    end

  end

  private

  def tasks_params
    params.require(:task).permit(:description)
  end





end
