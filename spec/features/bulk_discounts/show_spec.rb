require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my bulk discount show page' do
  before :each do
    @merchant = Merchant.create(name: "Joe")
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.23, quantity_threshold: 10)

    visit "merchant/#{@merchant.id}/bulk_discounts/#{@discount1.id}"
  end

  it "I see Bulk Discount stats" do
    expect(page).to have_content("Bulk Discount Percentage:")
    expect(page).to have_content("Quantity Threshold:")
    expect(page).to have_content("Status:")
    expect(page).to have_content("#{@discount1.percent * 100}%")
    expect(page).to have_content(@discount1.quantity_threshold)
    expect(page).to have_content(@discount1.status)
  end

  it "I can update discount" do
    expect(page).to have_button("Update Discount")
    click_button("Update Discount")
    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount1))
  end


end
