class CommentsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :comment_of_correct_user, :load_var_for_destroy, only: :destroy
  before_action :load_var_for_create, only: :create
  load_and_authorize_resource

  def create
    respond_to do |format|
      if @comment.save
        format.html{redirect_to @article}
        format.js
      else
        flash[:danger] = t ".comment_failed"
        format.html{redirect_to @article}
      end
    end
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html{redirect_to @article}
        format.js
      else
        flash[:danger] = t ".delete_failed_msg"
        format.html{redirect_to @article}
      end
    end
  end

  private

  def load_var_for_create
    @article = News.find_by id: params[:article_id]
    return unless @article
    @comment = @article.comments.build comment_params
    @comment.user_id = current_user.id
  end

  def load_var_for_destroy
    @article = @comment.commentable
  end

  def comment_params
    params.require(:comment).permit :content
  end

  def comment_of_correct_user
    @comment = current_user.comments.find_by id: params[:id]
    return unless @comment.nil?
    flash[:danger] = t ".wrong_user"
    redirect_to root_url
  end
end
