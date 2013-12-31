class PostsController < ApplicationController
  before_filter :authorize, except: %i[edit update]

  def index
    @posts = Post.all * 10
  end

  def show
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    post = Post.find(params[:id])
    post.update_attributes post_params
    redirect_to edit_post_path post
  end

  protected
  def post_params
    params.require(:post).permit(*(%i[title] + Post.crop_attributes))
  end
end