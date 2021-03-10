require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my bulk discount show page' do
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

  it "I see Bulk Discount stats" do
    # visit "merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}"
    visit merchant_bulk_discount_path(@merchant.id, @discount1.id)
    expect(page).to have_content("Bulk Discount Percentage:")
    expect(page).to have_content("Quantity Threshold:")
    expect(page).to have_content("Status:")
    expect(page).to have_content("#{@discount1.percent * 100}%")
    expect(page).to have_content(@discount1.quantity_threshold)
    expect(page).to have_content(@discount1.status)
  end

  it "I can update discount" do
    visit merchant_bulk_discount_path(@merchant.id, @discount1.id)
    expect(page).to have_button("Update Discount")
    click_button("Update Discount")
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount1))

    fill_in :percent, with: 0.25
    fill_in :quantity_threshold, with: 15
    click_button("Update Discount")
    expect(current_path).to eq(merchant_bulk_discount_path(@merchant.id, @discount1.id))
    expect(page).to have_content("25.0%")
    expect(page).to have_content(15)
  end

  it "I cannot delete or update on pending discount" do
    visit merchant_bulk_discount_path(@merchant.id, @discount2.id)
    expect(page).to_not have_content("Delete Discount")
  end


end
