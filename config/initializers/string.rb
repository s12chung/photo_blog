class String
  def http_url
    sub(/\Ahttps:\/\//, "http://")
  end
end