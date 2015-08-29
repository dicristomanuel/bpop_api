class Fbpost < ActiveRecord::Base
	belongs_to :user
	has_many   :fblikes, dependent: :destroy
	has_many   :fbcomments, dependent: :destroy

	validates  :bpopToken, presence: true
	validates  :fb_post_id, uniqueness: true

	serialize  :likesGenderPercentage, Hash
	serialize  :commentsGenderPercentage, Hash
end
