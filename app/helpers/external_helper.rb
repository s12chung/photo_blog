module ExternalHelper
  FLOWTYPE_TYPES = {
      layout: { minFont: 12, maxFont: 30},
      read: { minFont: 20, maxFont: 30}
  }
  def flowtype(type=:layout)
    content_for :flowtype, custom_flowtype(type, "'body'")
  end
  def custom_flowtype(type=:layout, selector="data_behavior('flowtype')")
    content_tag(:script, raw("$(#{selector}).flowtype(#{FLOWTYPE_TYPES[type].to_json});"))
  end

  def picturefill(uploader, options={})
    image_tag nil, options.merge(
        sizes: uploader.picturefill_size,
        srcset: %i[phone tablet desktop retina].map { |device| uploader.send(device).picturefill_src }.join(", "),
        data: { behavior: "picturefill" }
    )
  end

  def social_networks_tags
    Rails.cache.fetch [:social_networks_tags, request.host_with_port] do
      (data_to_tags(facebook_default) + data_to_tags(twitter_default)).join.html_safe
    end
  end

  def social_networks(model)
    content_for :identity do
      Rails.cache.fetch [model, :social_networks, request.host_with_port] do
        (data_to_tags(facebook_default.deep_merge(model.to_facebook)) +
            data_to_tags(twitter_default.deep_merge(model.to_twitter))).join.html_safe
      end
    end
  end

  private
  def social_networks_default
    {
        title: title == title_default ? site_name : title,
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
            site_name: site_name
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