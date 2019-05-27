class User < ApplicationRecord

  include DeviseTokenAuth::Concerns::User

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  before_create :generate_authentication_token!

  validates_uniqueness_of :auth_token

  has_many :tasks, dependent: :destroy
  

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: auth_token)
  end
         
end
