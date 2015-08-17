class Fbpost < ActiveRecord::Base
	has_many :fblikes, dependent: :destroy
	has_many :fbcomments, dependent: :destroy

	validates :bpopToken, presence: true

	serialize :likesGenderPercentage, Hash
	serialize :commentsGenderPercentage, Hash
end
