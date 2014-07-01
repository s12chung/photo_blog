module PostsHelper
  def direction_arrow(direction)
    post = @post_hash[direction]
    if post
      content_tag :div, class: direction do
        content_tag :div, class: "container" do
          link_to image_tag("#{direction}.png"), post_path(post)
        end
      end
    end
  end
end