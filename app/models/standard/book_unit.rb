class Standard::BookUnit < ApplicationRecord
  belongs_to :subject
  belongs_to :book
  # has_many :book_histories
end
