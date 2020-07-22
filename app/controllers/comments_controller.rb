class CommentsController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]
  before_action :set_comment, only: [:update, :destroy]

  def index
    comments = Comment.where(location_id: params[:location_id])
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
