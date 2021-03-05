require 'rails_helper'

RSpec.describe 'As a merchant, when I visit my bulk discount show page' do
  before :each do
    @discount1 = Merchant.first.bulk_discounts.create!(percent: 23, quantity_threshold: 10)

  end




end
