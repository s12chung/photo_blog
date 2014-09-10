module PostsHelper
  def direction_arrow(change)
    post = @post.adjacent change
    if post
      content_tag :div, class: Post.direction(change) do
        content_tag :div, class: "container" do
          link_to image_tag("arrows/#{Post.direction(change)}.png"), post_path(post), data: { behavior: "photo_box_#{Post.direction(change)}" }
        end
      end
    end
  end
end