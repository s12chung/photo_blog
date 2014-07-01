module ExternalHelper
  def picturefill(uploader, options={})
    image_tag nil, options.merge(
        sizes: "100vw",
        srcset: %i[phone tablet desktop retina].map { |device| uploader.send(device).picturefill_src }.join(", "),
        data: { behavior: "picturefill" }
    )
  end

  def social_networks_tags
    (data_to_tags(facebook_default) + data_to_tags(twitter_default)).join.html_safe
  end

  def social_networks(model)
    content_for :identity do
      (data_to_tags(facebook_default.deep_merge(model.to_facebook)) +
          data_to_tags(twitter_default.deep_merge(model.to_twitter))).join.html_safe
    end
  end

  private
  def social_networks_default
    {
        title: title,
        description: description,
        url: request.original_url,
        image: logo_url
    }
  end
  def facebook_default
    {
        fb: {
            app_id: ENV['FACEBOOK_KEY'],
            admins: ENV['FACEBOOK_ADMINS'],
        },
        og: social_networks_default.merge(
            site_name: title_default
        )
    }
  end
  def twitter_default
    {
        twitter: social_networks_default.merge(
            card: :summary,
            site: "@TravelCaptions",
            creator: "@s12chung"
        )
    }
  end

  def data_to_tags(data, namespace="")
    tags = []
    data.each do |type, value|
      type = "#{namespace}#{type}"
      if value.class == Hash
        if type == "og:image" && value[:url]
          tags << tag(:meta, property: type, content: value[:url])
        end
        tags += send(__method__, value, "#{type}:")
      elsif value.class == Array
        value.each { |v| tags << tag(:meta, property: type, content: v) }
      elsif value.present?
        tags << tag(:meta, property: type, content: value)
      end
    end
    tags
  end
end