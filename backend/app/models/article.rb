class Article < ApplicationRecord
    belongs_to :user
    has_many :viewers
    has_many :comments
end
