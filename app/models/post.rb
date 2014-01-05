class Post
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :markdown
  field :date, type: Date
  field :draft, type: Boolean

  mount_uploader :photo, PhotoUploader
  CROP_TYPES = %i[x y w h]
  CROP_ATTRIBUTES = CROP_TYPES.map { |coord| "crop_#{coord}".to_sym }
  CROP_ATTRIBUTES.each do |attribute|
    field attribute, type: BigDecimal
  end
  SUMMARY_CUTOFF = "[\u2026]"

  after_update do
    unless (changed & self.class.crop_attributes.map(&:to_s)).empty?
      photo.recreate_versions!(:index)
    end
  end

  def coords
    coords = {}
    CROP_TYPES.each do |crop_type|
      coords[crop_type] = self.send("crop_#{crop_type}").to_f
    end
    coords
  end

  def markdown=(markdown)
    if markdown.include? "\""
      raise("You have quotes!")
    end
    markdown = markdown.clone
    markdown.gsub!("...", "\u2026")
    markdown.gsub!(" - ", "\u2014")
    super markdown
  end


  def clean_markdown
    markdown.sub(SUMMARY_CUTOFF, "")
  end
  def markdown_html
    process_markdown clean_markdown
  end
  def summary_html
    process_markdown markdown.split(SUMMARY_CUTOFF).first + "\u2026"
  end

  protected
  def process_markdown(markdown)
    markdown_options = %w/autolink no_intra_emphasis/
    renderer_options = %w/hard_wrap/
    renderer = Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(Hash[renderer_options.map {|o| [o.to_sym, true]}]),
        Hash[markdown_options.map {|o| [o.to_sym, true]}])
    renderer.render(markdown).html_safe
  end

  class << self
    def crop_types
      CROP_TYPES
    end
    def crop_attributes
      CROP_ATTRIBUTES
    end
  end
end