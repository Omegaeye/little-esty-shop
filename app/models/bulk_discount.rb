class BulkDiscount < ApplicationRecord
  belongs_to :merchant

  enum status: [:inactive, :active]
end
