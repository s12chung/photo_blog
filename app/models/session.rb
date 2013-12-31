class Session
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::SecurePassword
  has_secure_password(validations: false)

  field :username
  field :password_digest
  field :auth_token

  validates :username, :auth_token, presence: true
  validates :password, presence: true, on: :create
  before_create { raise "Password digest missing on new record" if password_digest.blank? }

  after_initialize do
    generate_token
  end

  def generate_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  class << self
    def authenticate(username, password)
      session = self.where(username: username).first
      if session && session.authenticate(password)
        session.generate_token
        session.save
        session.auth_token
      else
        false
      end
    end

    def authenticated?(auth_token)
      !!self.where(auth_token: auth_token).first
    end
  end
end