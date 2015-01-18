class PostsController < ApplicationController
  before_filter :authorize, except: %i[index show]

  def index
    @posts = authenticated? ? Post.all.desc(:updated_at) : Post.published.to_a
  end

  def show
    @post = Post.find(params[:id])

    if html? && user_agent.mobile?
      index
    end
  end

  def create
    if params[:post]
      post = Post.create(create_params)
      redirect_to edit_post_path post
    else
      redirect_to posts_path
    end
  end

  def edit
    @post = Post.find(params[:id])
    js params: { ratio: Post::RATIO.to_f, cached_coords: @post.coords }
  end

  def update
    post = Post.find(params[:id])
    post.update_attributes update_params
    redirect_to edit_post_path post
  end

  def destroy
    Post.find(params[:id]).destroy
    redirect_to posts_path
  end

  def toggle_publish
    post = Post.find(params[:id])
    post.toggle_publish!
    redirect_to edit_post_path post
  end

  protected
  def create_params
    params.require(:post).permit(:photo)
  end

  def update_params
    params.require(:post).permit(*(%i[text] + Post::CROP_ATTRIBUTES))
  end
end