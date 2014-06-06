class PostsController < ApplicationController
  before_filter :authorize, except: %i[index show show_content]

  def index
    @posts = Post.published
  end

  def show
    @post = Post.find(params[:id])

    unless user_agent.mobile?
      @published_posts_size = Post.published.size
      @post_hash = {
          left: Post.where(publish_order: (@post.publish_order - 1) % @published_posts_size).first,
          right: Post.where(publish_order: (@post.publish_order + 1) % @published_posts_size).first
      }
    end
  end
  def show_content
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
    params.require(:post).permit(*(%i[title date markdown footnote_text] + Post.crop_attributes))
  end
end