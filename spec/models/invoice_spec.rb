require 'rails_helper'
require 'date'
RSpec.describe Invoice, type: :model do
  before :each do
    @customer = Customer.create(first_name: "Bob", last_name: "Hash")
    @merchant = Merchant.create(name: "Joe")
    @shroe = Merchant.find(1)
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.20, quantity_threshold: 10)
    @discount2 = @merchant.bulk_discounts.create!(percent: 0.1, quantity_threshold: 5)
    @discount3 = @shroe.bulk_discounts.create!(percent: 0.1, quantity_threshold: 5)
    @discount4 = @shroe.bulk_discounts.create!(percent: 0.2, quantity_threshold: 10)
    @item = @merchant.items.create(name: "JoJo", description: "YoYo", unit_price: 1)
    @item2 = @merchant.items.create(name: "LaLa", description: "String", unit_price: 1)
    @item3 = @merchant.items.create(name: "Hat", description: "big", unit_price: 1)
    @invoice1 = @customer.invoices.create(status: 0)
    @invoice2 = @customer.invoices.create(status: 0)
    @invoice_item1 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 5, unit_price: 1, status: "pending")
    @invoice_item2 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 10, unit_price: 1, status: "shipped")
    @invoice_item3 = InvoiceItem.create(invoice_id: @invoice2.id, item_id: @item.id, quantity: 5, unit_price: 1, status: "shipped")
    @invoice_item4 = InvoiceItem.create(invoice_id: @invoice2.id, item_id: @item.id, quantity: 10, unit_price: 1, status: "shipped")
    @invoice_item5 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 2, unit_price: 1, status: "shipped")
  end

  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
  end

  it 'status can be in_progress' do
    invoice12 = Invoice.find(12)
    expect(invoice12.status).to eq("in_progress")
    expect(invoice12.cancelled?).to eq(false)
    expect(invoice12.completed?).to eq(false)
    expect(invoice12.in_progress?).to eq(true)
  end

  it 'status can be cancelled' do
    invoice29 = Invoice.find(29)
    expect(invoice29.status).to eq("cancelled")
    expect(invoice29.cancelled?).to eq(true)
    expect(invoice29.completed?).to eq(false)
    expect(invoice29.in_progress?).to eq(false)
  end

  it 'status can be completed' do
    invoice17 = Invoice.find(17)
    expect(invoice17.status).to eq("completed")
    expect(invoice17.cancelled?).to eq(false)
    expect(invoice17.completed?).to eq(true)
    expect(invoice17.in_progress?).to eq(false)
  end

  describe 'instance methods' do
    describe '#total_revenue' do
      it "gets sum of revenue for all invoice items on the invoice" do
        invoice17 = Invoice.find(17)

        expect(invoice17.total_revenue).to eq(0.2474251e7)
      end
    end
    
      it "test discount rev" do
        invoice = Invoice.find(29)
        expect(invoice.discount_rev.first.discount_revenue.to_f).to eq(134152.0)
        expect(invoice.discount_rev.first.quantity).to eq(10)
        expect(invoice.discount_rev.first.percent.to_f).to eq(0.2)
        expect(invoice.discount_rev.uniq.size).to eq(2)
        expect(invoice.discount_rev.uniq.last.quantity).to eq(9)
        expect(invoice.discount_rev.uniq.last.percent).to eq(0.1)
      end

      it "test discounted_revenue" do
        invoice = Invoice.find(29)
        expect(invoice.discounted_revenue.class).to eq(BigDecimal)
        expect(invoice.total_revenue - invoice.discounted_revenue).to eq(invoice.discount_rev.uniq.sum(&:discount_revenue))
      end

      it "test discounted_item_id" do
        expect(@invoice1.discounted_item_id(@invoice_item1.id)).to eq(@discount2.id)
        expect(@invoice1.discounted_item_id(@invoice_item2.id)).to eq(@discount1.id)
      end
      it "test discounted_invoice_item" do
        invoice = Invoice.find(29)
        expect(@invoice1.discounted_invoice_item(@invoice_item1.id)).to eq(@invoice_item1.quantity * @invoice_item1.unit_price * @discount2.percent)
      end

      it "test render_id" do
        expect(@invoice1.render_id(@invoice_item1.id)).to eq("id")
        expect(@invoice1.render_id(@invoice_item5.id)).to eq("zero")
      end

  end






end
