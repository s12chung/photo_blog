if user_agent.mobile?
  json.posts_size @published_posts_size
  json.post_index @post.publish_order
  json.popup_content render("content")

  json.comments_content render("layouts/comments")
end