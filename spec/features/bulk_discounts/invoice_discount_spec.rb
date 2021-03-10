require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
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
    @invoice_item5 = InvoiceItem.create(invoice_id: @invoice1.id, item_id: @item.id, quantity: 2, unit_price: 1, status: "shipped")
    visit "merchant/#{@merchant.id}/invoices/#{@invoice1.id}"
  end

  describe "When I visit Merchant Invoices show Page " do
    it "I see the invoice total revenue and revenue after discount" do
      expect(page).to have_content("Discount")
      expect(page).to have_content("Total Revenue after discount:")
      expect(page).to have_content(@invoice1.discounted_revenue)

    end

    it "I see invoice id as link" do
      within "#discount-#{@discount2.id}" do
        expect(page).to have_link("Discount Id: ##{@discount2.id}")
      end

      within "#discount-#{@discount1.id}" do
        expect(page).to have_link("Discount Id: ##{@discount1.id}")
      end
    end

    it "I see Discount amount" do
      expect(page).to have_content("Discount Amount:")
      expect(page).to have_content(@invoice1.discount_rev.uniq.first.discount_revenue)
      expect(page).to have_content(@invoice1.discount_rev.uniq.last.discount_revenue)
    end

  end
end
