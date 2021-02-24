require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'class methods' do
    describe '::top_5_customers_with_success' do
      it "gets the top 5 customers with successful transactions overall" do
        results = Customer.top_5_customers_with_success

        # expect(results.size).to eq(5)
        expect(results.first.first_name).to eq("Leo")
        expect(results.first.transaction_count).to eq(5)
        expect(results.last.last_name).to eq("Zulauf")
        expect(results.last.transaction_count).to eq(4)
        expect(results.include?("Mariah")).to eq(false)
      end
    end

    describe '::top_customer_by_merchant' do
      it "gets the top 5 customers with successful transactions for a specific merchant" do
        merchant = Merchant.all.first
        results = Customer.top_customer_by_merchant(merchant.id)

        # expect(results.size).to eq(5)
        expect(results.first.first_name).to eq("Parker")
        expect(results.first.transaction_count).to eq(8)
        expect(results.last.last_name).to eq("Erdman")
        expect(results.last.transaction_count).to eq(4)
        expect(results.include?("Mariah")).to eq(false)
      end
    end
  end

  describe 'instance methods' do
    describe '::full_name' do
      it "combines first and last name" do
        customer = Customer.find(4)

        expect(customer.full_name).to eq("#{customer.first_name} #{customer.last_name}")
      end
    end
  end
end
