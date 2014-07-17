class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial
  include Mongoid::Slug

  include HasMarkdown

  field :title, default: "Post Title"
  field :description
  field :tags
  field :date, type: Date, default: -> { Date.today }
  field :place
  field :address
  field :position, type: Point, default: -> { Mongoid::Geospatial::Point.new(0,0) }

  field :markdown, default: "A post is just the beginning."
  field :footnote_text

  field :published_at, type: ActiveSupport::TimeWithZone
  field :published, type: Boolean, default: false
  field :publish_order, type: Integer

  CROP_TYPES = %i[x y w h]
  CROP_ATTRIBUTES = CROP_TYPES.map { |coord| "crop_#{coord}".to_sym }
  CROP_ATTRIBUTES.each { |attribute| field attribute, type: BigDecimal }
  RATIO = Rational(14, 3)
  TO_CROP_WIDTH = 345
  field :carrierwave_dimensions, type: Hash, default: {}
  mount_uploader :photo, PhotoUploader

  slug :title do |post|
    post.slug_builder.to_url(replace_whitespace_with: "_")
  end
  METADATA_FIELDS = %i[title description date tags place address]

  scope :published, -> { where(published: true).desc(:publish_order) }

  before_update do
    if crop_changed?
      photo.recreate_versions!(:index)
    end
  end

  METADATA_BREAK = "=========="
  FOOTNOTES_BREAK = "=== Footnotes ==="
  def post_string=(post_string)
    self.metadata, content = post_string.split(METADATA_BREAK).map(&:strip)
    self.markdown, self.footnote_text = content.split(FOOTNOTES_BREAK).map(&:strip)
  end
  def post_string
    post_string = []
    METADATA_FIELDS.each_with_index do |field, index|
      post_string << "#{field.to_s.titleize}: #{send(field)}\n"
      if index % 2 == 1 && index != METADATA_FIELDS.size - 1
        post_string << "\n"
      end
    end
    post_string << "\n#{METADATA_BREAK}\n\n" << markdown << "\n\n\n#{FOOTNOTES_BREAK}\n" << footnote_text
    post_string.join
  end

  def metadata=(metadata)
    metadata.each_line do |line|
      line = line.strip
      unless line.empty?
        key, value = line.split(":").map(&:strip)
        key.downcase!
        if METADATA_FIELDS.include? key.to_sym
          if key == "date"
            value = Date.new(*value.split("-").map(&:to_i))
          end
          send("#{key}=", value)
        end
      end
    end
  end

  def description
    @description ||= self.class.process_markdown(has_content? ? super : markdown, HasMarkdown::PlainTextRenderer)
  end

  def has_content?
    !!markdown.index(/\r\n/)
  end

  def toggle_publish!
    if published
      update_attributes(published_at: nil,
                        publish_order: nil,
                        published: false)
      self.class.published.each_with_index do |post, index|
        post.update_attribute :publish_order, index
      end
    else
      update_attributes(published_at: Time.zone.now,
                        publish_order: self.class.published.size,
                        published: true)
    end
  end

  def adjacent(change=nil)
    @adjacent ||= if publish_order
                    adjacent = {}
                    [-1, 1].each do |change|
                      adjacent[change] = self.class.where(publish_order: publish_order + change).first
                    end
                    adjacent
                  else
                    {}
                  end
    if change.blank?
      @adjacent.values
    else
      @adjacent[change]
    end
  end

  def locale
    address.match(/japan/i) ? :jp : :kr
  end

  def crop_changed?
    !(changed & self.class::CROP_ATTRIBUTES.map(&:to_s)).empty?
  end
  def recreate_versions!
    photo.recreate_versions!
    save
  end
end