class PostsController < ApplicationController
  before_filter :authorize, except: %i[index show show_content]

  def index
    @posts = authenticated? ? Post.all : Post.published.to_a
  end

  def show
    @post = Post.find(params[:id])

    if user_agent.mobile?
      index
    end
  end
  def show_content
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
    js params: { ratio: Post::RATIO, cached_coords: @post.coords }
  end

  def update
    post = Post.find(params[:id])
    post.update_attributes update_params
    redirect_to edit_post_path post
  end

  def toggle_publish
    post = Post.find(params[:id])
    post.toggle_publish!
    redirect_to edit_post_path post
  end

  protected
  def update_params
    params.require(:post).permit(*(%i[text] + Post::CROP_ATTRIBUTES))
  end
end