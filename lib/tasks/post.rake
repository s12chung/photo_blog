namespace :post do
  desc "Create a post for each image in db/photos"
  task :photo_create => :environment do
    Dir[Rails.root.join('db', 'photos', '*.*')].each do |file|
      Post.create(photo: File.new(file))
    end
  end

  task :create_template, %i[title] => :environment do |t, args|
    post = Post.new(args[:title].blank? ? {} : { title: args[:title] })
    file = File.new("#{post.title}.md", "w")
    file.puts(post.text)
    file.close
  end
end