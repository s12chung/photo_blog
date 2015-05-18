# run in prod
# wget -m localhost:3000
task :export do
  `mongodump -d photo_blog_development`
  `#{YAML.load_file('./config/strings.yml').symbolize_keys[:mongo_export]}`
end