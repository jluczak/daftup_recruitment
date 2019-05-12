# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discount, type: :model do
  it 'has a valid factory' do
    expect(FactoryBot.create(:discount)).to be_valid
  end

  let(:discount) { FactoryBot.create(:discount) }
  subject { discount }

  describe 'database columns' do
    it { is_expected.to have_db_column :name }
    it { is_expected.to have_db_column :kind }
    it { is_expected.to have_db_column :price }
    it { is_expected.to have_db_column :count }
  end

  describe 'validations' do
    context 'standard validations' do
      it { expect(subject).to validate_presence_of(:name) }
      it { expect(subject).to validate_inclusion_of(:kind).in_array(%w[set extra]) }
    end

    context 'custom validations - sets' do
      subject { FactoryBot.build(:discount, name: 'BBQ', kind: 'set', price: nil, count: nil) }
      it 'validates presence of price for sets' do
        expect(subject).to_not be_valid
      end
      subject { FactoryBot.build(:discount, name: 'BBQ', kind: 'set', price: 11.99, count: 2) }
      it 'validates absence of count for sets' do
        expect(subject).to_not be_valid
      end
    end

    context 'custom validations - extras' do
      subject { FactoryBot.build(:discount, name: '3 for 2', kind: 'extra', price: nil, count: nil) }
      it 'validates presence of count for extras' do
        expect(subject).to_not be_valid
      end
      subject { FactoryBot.build(:discount, name: '3 for 2', kind: 'extra', price: 11.99, count: 2) }
      it 'validates absence of price for sets' do
        expect(subject).to_not be_valid
      end
    end
  end

  describe 'relations' do
    it { should have_and_belong_to_many :products }
  end
end
