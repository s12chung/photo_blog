class PostsController < ApplicationController
  before_filter :authorize, except: %i[index show show_content]

  def index
    @posts = authenticated? ? Post.all : Post.published
  end

  def show
    @post = Post.find(params[:id])

    unless user_agent.mobile?
      @published_posts_size = Post.published.size
      @post_hash = {
          left: @post.adjacent(-1),
          right: @post.adjacent
      }
    end
  end
  def show_content
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
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
    params.require(:post).permit(*(%i[title date place address markdown footnote_text] + Post.crop_attributes))
  end
end