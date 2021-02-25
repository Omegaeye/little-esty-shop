class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices, dependent: :destroy
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def full_name
     [first_name, last_name].join(' ')
  end

  def self.top_5_customers_with_success
    select('customers.first_name, customers.last_name, count(transactions.id) as transaction_count')
    .joins(invoices: :transactions)
    .where(transactions: {result: 0})
    .group(:id)
    .order('transaction_count desc')
    .limit(5)
  end

  def self.top_customer_by_merchant(merchant_id)
    joins(invoices: [:transactions, :items])
    .select('customers.*, count(transactions.id) as transaction_count')
    .where(transactions: {result: 0})
    .where(items: {merchant_id: merchant_id})
    .group(:id)
    .order(transaction_count: :desc)
    .limit(5)
  end
end
