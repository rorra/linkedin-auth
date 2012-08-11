class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :linkedin_positions
  has_many :linkedin_companies, through: :linkedin_positions

  has_many :user_connections
  has_many :linkedin_connections, through: :user_connections

  has_many :user_groups
  has_many :linkedin_groups, through: :user_groups

  belongs_to :linkedin_location

  def linkedin_client
    client = LinkedIn::Client.new(LINKEDIN_KEY, LINKEDIN_SECRET)
    client.authorize_from_access(self.linkedin_token, self.linkedin_secret)
    client
  end
end
