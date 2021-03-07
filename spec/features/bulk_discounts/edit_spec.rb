require 'rails_helper'

RSpec.describe 'As a merchant, when I visit a Merchant bulk discount Show Page' do
  before :each do
    @merchant = Merchant.create(name: "Joe")
    @discount1 = @merchant.bulk_discounts.create!(percent: 0.23, quantity_threshold: 10)
    @discount2 = @merchant.bulk_discounts.create!(percent: 0.1, quantity_threshold: 5)

  end

  describe 'I can click a button to update that discount' do
    it 'I am taken to an edit form with the current information pre-populated' do
      visit merchant_bulk_discount_path(@merchant, @discount1)

      expect(page).to have_button("Update Discount")
      click_button("Update Discount")
      expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant, @discount1))

      expect(page).to have_field("percent")
      expect(page).to have_field("quantity_threshold")

      fill_in :percent, with: 0.3
      fill_in :quantity_threshold, with: 15
      click_button("Update Discount")
      expect(current_path).to eq(merchant_bulk_discount_path(@merchant, @discount1))
      visit merchant_bulk_discount_path(@merchant, @discount2)
      expect(page).to have_content("10.0")
    end
  end
end
