require 'rails_helper'

RSpec.describe Transaction, type: :model do
  it { belong_to :invoice }
end
