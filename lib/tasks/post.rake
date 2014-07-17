namespace :post do
  desc "Create a post for each image in db/photos"
  task :photo_create => :environment do
    Dir[Rails.root.join('db', 'photos', '*.*')].each do |file|
      Post.create(photo: File.new(file))
    end
  end

  task :create_template => :environment do
    file = File.new("new post.md", "w")
    file.puts(Post.new.post_string)
    file.close
  end
end