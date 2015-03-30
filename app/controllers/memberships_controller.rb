class MembershipsController < ApplicationController

  before_action :check_current_user
  before_action do
    @project = Project.find(params[:project_id])
  end
  before_action :check_member
  before_action :find_member, only: [:edit, :update ]
  before_action :count_owners

  def index
    @membership = @project.memberships.new
    @current_membership = current_user.memberships.find_by(project_id: @project.id)
  end

  def create
    @membership = @project.memberships.new(memberships_params)
    if @membership.save
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was added successfully"
    else
      render :index
    end
  end

  def show
  end

  def edit
  end

  def update
    @membership = @project.memberships.find(params[:id])
    if (@owner_num > 1)
      if @membership.update(params.require(:membership).permit(:role))
        redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was updated successfully"
      end
    else
        redirect_to project_memberships_path(@project), alert: "Projects must have at least one owner"
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    redirect_to projects_path, notice: "#{membership.user.full_name} successfully removed"
  end

  private
  def memberships_params
    params.require(:membership).permit(:user_id, :role)
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
    if current_user.memberships.find_by(project_id: @project.id) == nil
      flash[:alert] = 'You do not have access to that project'
      redirect_to projects_path
    end
  end

  def find_member
    @current_membership = current_user.memberships.find_by(project_id: @project.id)
      if @current_membership.role == "Owner" || @user.admin == true

      else
        flash[:alert] = 'You do not have access'
        redirect_to project_path(@project)
    end
  end

  def count_owners
    owner_array = []
    owner_array << @project.memberships.find_by(role: "Owner")
    @owner_num = owner_array.count
  end
end
