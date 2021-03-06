class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    if params[:search] == nil
      @posts = Post.all
    else
      @posts = Post.where "title like ?", "%" + params[:search] + "%"
    end

    @posts = @posts.order created_at: params[:sort] if params[:sort] != nil
    @posts = @posts.paginate :page => params[:page],
      :per_page => Settings.perpage
  end

  def show
    @comments = Comment.where(post_id: @post.id).order_by_created_at_desc
      .paginate :page => params[:page], :per_page => Settings.perpage
  end

  def new
    @post = Post.new
  end

  def create
    if logged_in?
      @post = Post.new(post_params)
      @post.user_id = current_user.id

      respond_to do |format|
        if @post.save
          format.html {redirect_to @post,
            notice: "Post was successfully created."}
        else
          format.html {render :new}
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update post_params
        format.html {redirect_to @post, notice: "Post was successfully updated."}
      else
        format.html {render :edit}
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html {redirect_to posts_url, notice: "Post was successfully destroyed."}
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit :title, :content
  end
end
