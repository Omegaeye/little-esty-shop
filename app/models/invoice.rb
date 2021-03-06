class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :invoice_items

  enum status: [:in_progress, :cancelled, :completed]

  scope :incomplete_invoices, -> { includes(:invoice_items).where.not(status: 2).distinct.order(:created_at)}

  def total_revenue
    invoice_items.sum(&:revenue)
  end

  def discount(invoice_item_id)
    invoice_items
    .joins(:bulk_discounts)
    .where('invoice_items.quantity >= bulk_discounts.quantity_threshold')
    .select('invoice_items.*, (invoice_items.quantity * invoice_items.unit_price * bulk_discounts.percent) as discount_revenue, bulk_discounts.id as discount_id')
    .where(id: invoice_item_id)
    .order('bulk_discounts.percent DESC')
  end

  def discount_amount(invoice_item_id)
    return 0 if discount(invoice_item_id).empty?
    discount(invoice_item_id).first.discount_revenue
  end

  def discounted_revenue
    discounts = invoice_items.map do |item|
      discount_amount(item.id)
    end.sum
    return total_revenue - discounts
  end

  def discount_id(invoice_item_id)
    discount(invoice_item_id).first.discount_id
  end
end
