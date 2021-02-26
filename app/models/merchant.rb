class Merchant < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  enum status: [:enabled, :disabled]

  after_initialize :default

  def default
    self.status == "disabled"
  end

  def distinct_invoices
    invoices.distinct
  end
end
