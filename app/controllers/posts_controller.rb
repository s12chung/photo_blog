class PostsController < ApplicationController
  def index
    @posts = Post.all * 10
  end
end