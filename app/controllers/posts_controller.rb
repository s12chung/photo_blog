class PostsController < ApplicationController
  def index
    @posts = Post.all * 10
  end

  def show
  end

  def edit
  end
end