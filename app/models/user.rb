class User < ActiveRecord::Base
  has_many :fbposts, dependent: :destroy

  serialize  :tempPostsIdContainer, Array
end
