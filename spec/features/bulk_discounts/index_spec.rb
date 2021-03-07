require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my bulk discount index page' do
  before :each do
    @merchant = Merchant.first
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.23, quantity_threshold: 10)

    visit "merchant/1/bulk_discounts"
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
end