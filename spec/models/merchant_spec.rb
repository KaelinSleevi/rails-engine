require 'rails_helper'

RSpec.describe Merchant, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { should have_many :items }
  it { should have_many :invoices }
end
