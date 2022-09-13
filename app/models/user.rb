class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :user_rooms, dependent: :destroy
　has_many :chats, dependent: :destroy

  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :favorited_books, through: :favorites, source: :book

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}



  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def following?(user)
    followings.exists?(user.id)
  end

  def self.looks(search, word)
    if search == 'perfect_match'
      User.where(name: word)
    elsif search == 'forward_match'
      User.where('name LIKE ?', word + '%')
    elsif search == 'backward_match'
      User.where('name LIKE ?', '%' + word)
    elsif search == 'partial_match'
      User.where('name LIKE ?', '%' + word + '%')
    else
      User.all
    end
  end

end
