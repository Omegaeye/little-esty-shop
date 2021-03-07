require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my bulk discount index page' do
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

    visit "merchant/#{@merchant.id}/bulk_discounts"
  end

  it "I see all of my bulk discounts and quantity thresholds with links" do
      expect(page).to have_content("Bulk Discounts Percentage")
      expect(page).to have_content("Quantity Threshold")

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content("#{@discount1.percent * 100}%")
      expect(page).to have_content(@discount1.quantity_threshold)
      expect(page).to have_button("Discount Page")
      click_button("Discount Page")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount1))
    end
  end

  # it "I see Upcoming Holidays" do
  #   expect(page).to have_content("Memorial Day")
  #   expect(page).to have_content("2021-05-31")
  # end

  it "I can create new bulk discount" do
    expect(page).to have_button("New Discount")
    click_button("New Discount")
    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))
  end

  it "I can delete bulk discount" do

    within "#discount-#{@discount1.id}" do
      expect(page).to have_button("Delete Discount")
      click_button("Delete Discount")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
  end

  it "I can delete bulk discount" do

    within "#discount-#{@discount2.id}" do
      expect(page).to_not have_button("Delete Discount")
    end
  end
end
