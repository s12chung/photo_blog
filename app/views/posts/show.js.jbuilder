json.post_index @post.publish_order
if @post.has_content?
  json.popup_content render("content")
end
json.photoswipe_content render("photoswipe_content")