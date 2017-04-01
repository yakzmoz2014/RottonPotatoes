class Movie < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  has_many :movie_relationships
  has_many :members, through: :movie_relationships, source: :user
  validates :title, presence: true
  validates :description, presence: true


  has_attached_file :image, styles: {
    medium: "200x300>", thumb: "100x100>"
    }, default_url: "/images/:style/missing.png"

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
