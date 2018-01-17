require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "#status" do
    it {is_expected.to validate_presence_of(:status)}
    it {is_expected.to allow_value(:todo).for(:status)}
    it {is_expected.to allow_value(:done).for(:status)}
    it {is_expected.to define_enum_for(:status).with([:todo, :done])}
  end
  it {is_expected.to validate_presence_of(:name)}
  it "has a valid factory" do
    expect(FactoryBot.build(:task)).to be_valid
  end
end
