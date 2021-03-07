class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  has_many :items, through: :merchant
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  after_initialize :default, unless: :persisted?
  enum status: [:inactive, :active]
  validates_presence_of :percent, :quantity_threshold

  def default
    self.status = 0
  end

  def invoice_items_pending?
    invoice_items.where(status: :pending).where('quantity >= ?', self.quantity_threshold).empty?
  end

end
