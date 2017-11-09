class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def create
    post = Post.find_by id: params[:comment][:post_id]
    if can_comment? post
      @comment = Comment.new(comment_params)
      @comment.user_id = current_user.id

      respond_to do |format|
        if @comment.save
          format.html {redirect_to post, notice: "Comment was successfully created."}
        else
          format.html {render :new}
        end
      end
    else
      flash[:danger] = t ".You do not have permission to comment on this post"
      redirect_to post
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end


  def comment_params
    params.require(:comment).permit :post_id, :content
  end
end
