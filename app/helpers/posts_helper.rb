module PostsHelper
  def direction_arrow(direction)
    content_tag :div, class: direction do
      content_tag :div, class: "container" do
        link_to image_tag("#{direction}.png"), post_path(@post_hash[direction])
      end
    end
  end
end