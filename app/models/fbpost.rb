class Fbpost < ActiveRecord::Base
	has_many :fblikes, dependent: :destroy
	has_many :fbcomments, dependent: :destroy

	validates :bpop_token, presence: true

	serialize :likesGenderPercentage, Hash
	serialize :commentsGenderPercentage, Hash
end
