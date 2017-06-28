class Standard::Book < ApplicationRecord
  belongs_to :subject
  has_many :book_units
  # has_many :book_histories
end
