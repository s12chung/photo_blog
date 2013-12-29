class Session
  include Mongoid::Document
  include Mongoid::Timestamps

  field :auth_token

  class << self
    def generate
      self.delete_all
      self.create(auth_token: SecureRandom.urlsafe_base64).auth_token
    end

    def authenticated?(auth_token)
      self.first.auth_token == auth_token
    end
  end
end