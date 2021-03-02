require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it {should have_many :items}
    it {should have_many(:invoice_items).through(:items)}
    it {should have_many(:invoices).through(:invoice_items)}
    it {should have_many(:transactions).through(:invoices)}
    it {should have_many(:customers).through(:invoices)}
  end

  describe 'validations' do
    it {should validate_presence_of :name}
  end

  it 'is created with status disabled when not provided' do
    cool = Merchant.create!(name: "Cool Beans")

    expect(cool.status).to eq("disabled")
    expect(cool.disabled?).to eq(true)
    expect(cool.enabled?).to eq(false)
  end

  it 'can have status enabled' do
    cool = Merchant.create!(name: "Cool Beans")
    cool.update!(status: :enabled)

    expect(cool.status).to eq("enabled")
    expect(cool.disabled?).to eq(false)
    expect(cool.enabled?).to eq(true)
  end

  describe 'class methods' do
    describe '::top_5_by_revenue' do
      it 'returns top 5 merchants based on total revenue' do
        # Need test for this class method
      end
    end
  end

  describe 'instance methods' do
    describe '#distinct_invoices' do
      it "gets the distinct invoices for a merchant" do
        merchant = create(:merchant)
        item1 = create(:item, merchant_id: merchant.id)
        item2 = create(:item, merchant_id: merchant.id)
        invoice1 = create(:invoice)
        create(:invoice_item, item_id: item1.id, invoice_id: invoice1.id, status: :pending)
        create(:invoice_item, item_id: item2.id, invoice_id: invoice1.id, status: :pending)

        expect(merchant.distinct_invoices.pluck(:id)).to eq([invoice1.id])
      end
    end
  end
end
