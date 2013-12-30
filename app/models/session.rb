class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :username
  field :password
  field :auth_token

  validates :username, :password, :auth_token, presence: true

  after_initialize do
    generate_token
  end

  def generate_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  class << self
    def authenticate(username, password)
      session = self.where(username: username, password: password).first
      if session
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