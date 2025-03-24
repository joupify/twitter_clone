# == Schema Information
#
# Table name: hashtags
#
#  id           :bigint           not null, primary key
#  name         :string
#  tweets_count :integer          default(0)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_hashtags_on_name  (name)
#
class Hashtag < ApplicationRecord
  has_many :hashtaggings, dependent: :destroy
  has_many :tweets, through: :hashtaggings

  validates :name, presence: true, uniqueness: true

  Hashtag.order(tweets_count: :desc).limit(10)


  before_validation :downcase_name

  private

  def downcase_name
    self.name = name.downcase
  end
end
