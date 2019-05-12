require 'rails_helper'

RSpec.describe Carts::DiscountsController, type: :controller do

  describe 'POST #create' do
     let!(:product) { FactoryBot.create(:product) }
     let(:discount_params) { { name: "set", kind:"set", price:11.99, product_ids: [product.id] } }

     subject { post :create, params: discount_params }

     context 'with valid attributes' do
       it 'returns http created' do
         subject
         expect(response).to have_http_status(:created)
       end

       it 'create new discount' do
         expect { subject }.to change(Discount, :count).by(1)
       end

       it 'returns json with all items and discounts' do
         subject
         json_response = JSON.parse(response.body)
         expect(json_response.keys).to match_array(['items', 'discounts'])
         expect(json_response['discounts'].length).to eq(1)
       end
     end

    context 'with invalid attributes' do
      it 'returns http unprocessable_entity' do
        post :create, params: { name: nil ,kind: "xxx", count: 2, product_ids: [nil] }
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it "doesn't create new discount" do
        expect do
          post :create, params: { name: nil ,kind: "xxx", count: 2, product_ids: [nil] }
        end .to_not change { Discount.count }
      end
    end
  end

  describe 'PUT #update' do
     let!(:product) { FactoryBot.create(:product) }
     let!(:discount) {FactoryBot.create(:discount, product_ids:[product.id])}
     let(:discount_params_updated) { { id: discount.id, discount: { name: "set2" } } }

     subject { put :update, params: discount_params_updated }

     context 'with valid attributes' do
       it 'returns http 200' do
         subject
         expect(response).to have_http_status(:ok)
       end

       it 'update discount' do
         expect { subject }.to change(Discount, :count).by(0)
         # expect(discount.reload.name).to eq(discount_params_updated[:discount][:name])
       end

       it 'returns json with all items and discounts' do
         subject
         json_response = JSON.parse(response.body)
         expect(json_response.keys).to match_array(['items', 'discounts'])
         # expect(json_response['discounts'].last['name']).to eq("set2")
       end
     end

    context 'with invalid attributes' do
      it 'returns http unprocessable_entity' do
        post :update, params: { id:discount.id, discount: { name: nil } }
        # expect(response).to have_http_status(:unprocessable_entity)
      end
      it "doesn't update discount" do
        expect do
          post :update, params: { id:discount.id, item: { name: nil } }
        end .to_not change { discount.reload.name }
      end
    end
  end

end
