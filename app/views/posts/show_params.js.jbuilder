if user_agent.mobile?
  json.post_index @post.publish_order
  if @post.has_content?
    json.popup_content render("content")
  end

  json.comments_content render("layouts/comments")
end