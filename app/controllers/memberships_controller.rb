class MembershipsController < ApplicationController
  before_action :check_current_user
  before_action do
    @project = Project.find(params[:project_id])
  end

  def index
    @membership = @project.memberships.new
  end

  def create
    @membership = @project.memberships.new(memberships_params)
    if @membership.save
      redirect_to project_memberships_path(@project), notice: "#{@membership.user.full_name} was added succesfully"
    end
  end

  def show
  end

  def edit
  end

  def update

  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    redirect_to project_memberships_path(@project), notice: "#{membership.user.full_name} was deleted successfully"
  end

  private
  def memberships_params
    params.require(:membership).permit(:user_id, :role)
  end

  def check_current_user
    if current_user

    else
      redirect_to sign_in_path
      flash[:alert] = "You must sign in"
    end
  end
end
