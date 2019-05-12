require 'rails_helper'

RSpec.describe Product, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:product)).to be_valid
  end

  let(:product) { FactoryBot.create(:product) }
  subject { product }

  describe 'database columns' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :price }
  end

  describe 'validations' do
     it { expect(subject).to validate_presence_of(:name) }
     it { expect(subject).to validate_uniqueness_of(:name) }
     it { expect(subject).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe 'relations' do
    it { should have_one :item }
    it { should have_and_belong_to_many :discounts }
  end
end
