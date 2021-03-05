class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  after_initialize :default, unless: :persisted?
  enum status: [:inactive, :active]
  validates_presence_of :percent, :quantity_threshold

  def default
    self.status = 0
  end

end
