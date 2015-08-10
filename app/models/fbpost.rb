class Fbpost < ActiveRecord::Base
	has_many :fblikes, dependent: :destroy

	validates :user_token, presence: true
end
