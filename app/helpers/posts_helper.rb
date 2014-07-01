module PostsHelper
  def direction_arrow(change)
    post = @post.adjacent change
    if post
      content_tag :div, class: Post.direction(change) do
        content_tag :div, class: "container" do
          link_to image_tag("#{Post.direction(change)}.png"), post_path(post)
        end
      end
    end
  end
end