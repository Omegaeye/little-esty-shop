require 'rails_helper'

RSpec.describe 'As a merchant, when I visit a bulk discount index Page' do
  before :each do
    @merchant = Merchant.first
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.23, quantity_threshold: 10)
  end

  describe 'I can click a button to update that discount' do
    it 'I am taken to an edit form with the current information pre-populated' do
      visit merchant_bulk_discounts_path(@merchant)

      expect(page).to have_button("New Discount")
      click_button("New Discount")
      expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant))

      expect(page).to have_field("percent")
      expect(page).to have_field("quantity_threshold")

      fill_in :percent, with: 0.3
      fill_in :quantity_threshold, with: 15
      click_button("Add Discount")
      expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
    end
  end
end
