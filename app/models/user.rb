class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :create_profile

  has_one :profile, dependent: :destroy
  has_one :cover_photo, through: :profile

  has_many :posts,    -> { order(created_at: :desc) }, foreign_key: :author_id, dependent: :destroy
  has_many :comments, -> { order(created_at: :asc) },  foreign_key: :author_id, dependent: :destroy
  has_many :photos,   foreign_key: :author_id, dependent: :destroy
  has_many :likes,    foreign_key: :liker_id,  dependent: :destroy

  has_many :initiated_friendings, foreign_key: :friender_id, class_name: "Friending"
  has_many :friended_users, through: :initiated_friendings, source: :friend_recipient

  has_many :received_friendings, foreign_key: :friend_id, class_name: "Friending"
  has_many :users_friended_by, through: :received_friendings, source: :friend_initiator

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :gender, inclusion: ["Female", "Male", "Other"],
                     allow_blank: true, allow_nil: true

  def name
    "#{first_name} #{last_name}"
  end

  def friends
    users_friended_by.where(id: friended_users.pluck(:id))
  end

  def friend_requests
    users_friended_by.where.not(id: friended_users.pluck(:id))
  end

  def self.welcome_email(user_id)
    user = User.find(user_id)
    UserMailer.welcome(user).deliver!
  end
end
