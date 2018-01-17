require 'rails_helper'

RSpec.describe List, type: :model do
  it {is_expected.to validate_presence_of(:name)}
  it "has a valid factory" do
    expect(FactoryBot.build(:list)).to be_valid
  end
end
