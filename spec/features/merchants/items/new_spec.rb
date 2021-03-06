require 'rails_helper'

RSpec.describe 'As a merchant, when I vist my Merchant Items Index Page' do
  before :each do
    @merchant = Merchant.third
  end
  describe "I see a button to create a new item and I am taken to a form" do
    it "where I can create a new item" do
      visit new_merchant_item_path(@merchant)

      expect(page).to have_content("Create a New Item")
      fill_in 'name', with: 'My Fabu Item'
      fill_in 'description', with: 'This is a description'
      fill_in 'unit_price', with: '10.00'
      click_button 'Create Item'

      expect(current_path).to eq("/merchant/#{@merchant.id}/items")
      within ".all-items" do
        expect(page).to have_content("My Fabu Item")
      end
    end

    it "and I cannot create a new item without a name" do
      visit new_merchant_item_path(@merchant)

      expect(page).to have_content("Create a New Item")
      fill_in 'description', with: 'This is a description'
      fill_in 'unit_price', with: '10.00'
      click_button 'Create Item'

      expect(page).to have_content("Name can't be blank")
      expect(current_path).to eq("/merchant/#{@merchant.id}/items")
    end

    it "and I cannot create a new item without a current price" do
      visit new_merchant_item_path(@merchant)

      expect(page).to have_content("Create a New Item")
      fill_in 'name', with: 'My Fabu Item'
      fill_in 'description', with: 'This is a description'
      click_button 'Create Item'

      expect(page).to have_content("Unit price can't be blank")
      expect(page).to have_content("Unit price is not a number")
      expect(current_path).to eq("/merchant/#{@merchant.id}/items")
    end
  end
end
