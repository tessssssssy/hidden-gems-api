class CommentsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]

  def index
    rawComment = Comment.includes(:user).where(location_id: params[:location_id])
    if rawComment.length==0 
      comments = [0]
    else 
      comments = rawComment.map do |c|
        {id: c.id, body: c.body, user: c.user.username, created_at: c.created_at, thread_id: c.thread_id}
      end
    end
    render json: comments, status: 200
  end

  def create
    comment = current_user.comments.create(comment_params)
    if comment.errors.any?
      render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
    else
      render status: :created
    end
  end

  def update
    if @comment.update(comment_params)
      render status: :ok
    else
      render json: { errors: @comment.errors.full_messages },
             status: :unprocessable_entity
    end
  end  

  def destroy
    @comment.destroy
    render status: :ok
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :thread_id, :location_id, :user_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end


end
