# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Carts::ItemsController, type: :controller do
  describe 'POST #create' do
    let!(:product) { FactoryBot.create(:product) }
    let(:item_params) { { quantity: 5, product_id: product.id } }

    subject { post :create, params: item_params }

    context 'with valid attributes' do
      it 'returns http created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'create new item' do
        expect { subject }.to change(Item, :count).by(1)
        expect { subject }.to change(Item, :count).by(0)
      end

      it 'returns json with all items and discounts' do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(%w[items discounts])
        expect(json_response['items'].length).to eq(1)
      end
    end

    context 'with invalid attributes' do
      it 'returns http unprocessable_entity' do
        post :create, params: { product_id: nil }
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it "doesn't create new item" do
        expect do
          post :create, params: { product_id: 4 }
        end .to_not change { Item.count }
      end
    end
  end

  describe 'PUT #update' do
    let!(:product) { FactoryBot.create(:product) }
    let!(:item) { FactoryBot.create(:item, product_id: product.id) }
    let(:item_params_updated) { { id: item.id, item: { quantity: 10 } } }

    subject { put :update, params: item_params_updated }

    context 'with valid attributes' do
      it 'returns http 200' do
        subject
        expect(response).to have_http_status(:ok)
      end

      it 'update item' do
        expect { subject }.to change(Item, :count).by(0)
        # expect(item.reload.quantity).to eq(item_params_updated[:item][:quantity])
      end

      it 'returns json with all items and discounts' do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(%w[items discounts])
        # expect(json_response['items'].first['quantity']).to eq(10)
      end
    end

    context 'with invalid attributes' do
      it 'returns http unprocessable_entity' do
        post :update, params: { id: item.id, item: { quantity: nil } }
        # expect(response).to have_http_status(:unprocessable_entity)
      end
      it "doesn't update item" do
        expect do
          post :update, params: { id: item.id, item: { quantity: nil } }
        end .to_not change { item.reload.quantity }
      end
    end
  end
end
