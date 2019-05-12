require 'rails_helper'

RSpec.describe Item, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:item)).to be_valid
  end

  let(:item) { FactoryBot.create(:item) }
  subject { item }

  describe 'database columns' do
    it { is_expected.to have_db_column :quantity }
  end

  describe 'validations' do
     it { expect(subject).to validate_uniqueness_of(:product_id) }
     it { expect(subject).to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
     it { expect(subject).to validate_numericality_of(:quantity).only_integer }
  end

  describe 'relations' do
    it { should belong_to :product }
  end
end
