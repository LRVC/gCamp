class CommentsController < ApplicationController
  def create
    @comment = Comment.new(params.require(:comment).permit(:description))
    if @comment.save
      redirect_to project_tasks_path, notice: "Your comment has been created"
    end
  end
end
