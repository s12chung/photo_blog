class PostsController < ApplicationController
  before_filter :authorize, except: %i[index show]

  def index
    @posts = Post.all * 10
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    show
  end

  def update
    post = Post.find(params[:id])
    post.update_attributes post_params
    redirect_to edit_post_path post
  end

  protected
  def post_params
    params.require(:post).permit(*(%i[title date markdown] + Post.crop_attributes))
  end
end