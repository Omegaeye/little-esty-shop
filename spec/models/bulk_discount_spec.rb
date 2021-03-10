require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  before :each do
    @customer = Customer.create(first_name: "Bob", last_name: "Hash")
    @merchant = Merchant.create(name: "Joe")
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.20, quantity_threshold: 10)
    @discount2 = @merchant.bulk_discounts.create!(percent: 0.1, quantity_threshold: 5)
    @item = @merchant.items.create(name: "JoJo", description: "YoYo", unit_price: 1)
    @item2 = @merchant.items.create(name: "LaLa", description: "String", unit_price: 1)
    @item3 = @merchant.items.create(name: "Hat", description: "big", unit_price: 1)
    @invoice1 = @customer.invoices.create(status: 0)
    @invoice2 = @customer.invoices.create(status: 0)
    @invoice_item1 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 5, unit_price: 1, status: "pending")
    @invoice_item2 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 10, unit_price: 1, status: "shipped")
    @invoice_item3 = InvoiceItem.create(invoice_id: @invoice2.id, item_id: @item.id, quantity: 5, unit_price: 1, status: "shipped")
    @invoice_item4 = InvoiceItem.create(invoice_id: @invoice2.id, item_id: @item.id, quantity: 10, unit_price: 1, status: "shipped")

  end
  describe 'relationships' do
    it {should belong_to(:merchant)}
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
    it {should validate_presence_of(:percent)}
    it {should validate_presence_of(:quantity_threshold)}
  end

  it "able to get invoice items not pending" do
    expect(@discount2.invoice_items_pending?).to eq("empty")
    expect(@discount1.invoice_items_pending?).to eq("delete")
  end


end
