class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  scope :order_by_created_at_desc, -> {order created_at: :desc}
end
