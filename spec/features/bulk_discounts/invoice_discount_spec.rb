require 'rails_helper'

RSpec.describe 'Merchant Invoices Show Page' do
  before :each do
    @merchant = Merchant.first
    @invoice = @merchant.invoices.first
    @invoice_item = @invoice.invoice_items.first
    @customer = @invoice.customer
    @customer.update(address: '123 Main St', city: 'Denver', state: 'CO', zipcode: '80202')
    @customer.save
    visit "merchant/#{@merchant.id}/invoices/#{@invoice.id}"
  end

  describe "When I visit Merchant Invoices show Page " do
    it "I see the invoice total revenue and revenue after discount" do
      expect(page).to have_content("Discount")
      expect(page).to have_content("Total Revenue after discount:")
    end

  end
end
