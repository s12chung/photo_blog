module ExternalHelper
  def picturefill(uploader, options={})
    versions = user_agent.mobile? ? %i[phone tablet] : %i[desktop retina]
    image_tag nil, options.merge(
        sizes: "100vw",
        srcset: versions.map { |device| uploader.send(device).picturefill_src }.join(", "),
        data: { behavior: "picturefill" }
    )
  end

  def open_graph_tags
    open_graph_data_to_tags(open_graph_default).join.html_safe
  end
  def open_graph(model)
    content_for :identity do
      open_graph_data_to_tags(open_graph_default.deep_merge(model.to_facebook)).join.html_safe
    end
  end

  private
  def open_graph_default
    {
        fb: {
            app_id: ENV['FACEBOOK_KEY'],
            admins: ENV['FACEBOOK_ADMINS'],
        },
        og: {
            site_name: title_default,
            title: title,
            description: description,
            url: request.original_url,
            image: asset_url("logo.png").http_url,
        }
    }
  end

  def open_graph_data_to_tags(data, namespace="")
    tags = []
    data.each do |type, value|
      type = "#{namespace}#{type}"
      if value.class == Hash
        if type == "og:image" && value[:url]
          tags << tag(:meta, property: type, content: value[:url])
        end
        tags += open_graph_data_to_tags(value, "#{type}:")
      elsif value.class == Array
        value.each { |v| tags << tag(:meta, property: type, content: v) }
      elsif value.present?
        tags << tag(:meta, property: type, content: value)
      end
    end
    tags
  end
end