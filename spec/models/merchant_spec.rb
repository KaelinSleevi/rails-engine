require 'rails_helper'

RSpec.describe Merchant, type: :model do

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'class methods' do
    it "#search" do
      merchant_1 = Merchant.create!(name: "Kaelin")
      merchant_2 = Merchant.create!(name: "Elizabeth")

      expect(Merchant.search_for("Kae")).to eq(merchant_1)
      expect(Merchant.search_for("beth")).to eq(merchant_2)
    end
  end
end
