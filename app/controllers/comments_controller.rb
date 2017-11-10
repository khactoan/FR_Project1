class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def new
    @comment = Comment.new
  end

  def create
    post = Post.find_by id: params[:comment][:post_id]

    if can_comment? post
      @comment = Comment.new(comment_params)
      @comments = Comment.where(post_id: post.id).order_by_created_at_desc
        .paginate :page => params[:page], :per_page => Settings.perpage
      respond_to do |format|
        if @comment.save
          format.html {redirect_to post, notice: "Comment was successfully created."}
          format.js
          format.json {render :show, status: :created, location: @comment}
        else
          format.html {render :new}
          format.json {render json: @comment.errors,
            status: :unprocessable_entity}
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
    params.require(:comment).permit :post_id, :content, :user_id
  end
end
