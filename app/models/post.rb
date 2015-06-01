class Post < ActiveRecord::Base
  belongs_to :author, class_name: "User"

  has_many :likes, as: :likable, dependent: :destroy
  has_many :likers, through: :likes
  has_many :comments, -> { order(created_at: :asc) }, as: :commentable, dependent: :destroy

  validates :author,  presence: true
  validates :content, presence: true, length: { maximum: 255 }

  scope :friends_posts, -> user { where(author_id: user.friends.pluck(:id) << user.id) }
  scope :posted_since, -> time { where("created_at > ?", time) }
  scope :popular_posts, -> { where("likes_count > 2").order(likes_count: :desc) }
  scope :recently_popular, -> user, period { friends_posts(user).
                                             posted_since(7.days.ago).
                                             popular_posts.limit(8) }

  # load items for an index of posts with comments and likes
  def self.include_post_info
    includes(
    [:likers,
      :likes,
      author: [profile: :photo],
    comments: [:likers,
                :likes,
          :commentable,
                author: [profile: :photo]
              ]
    ])
  end
end
