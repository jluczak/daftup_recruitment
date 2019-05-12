require 'rails_helper'

RSpec.describe Carts::ItemsController, type: :controller do
  # it 'has a valid factory' do
  #   expect(FactoryBot.create(:item)).to be_valid
  # end
  #
  # let(:item) { FactoryBot.create(:item) }
  # subject { item }

  describe 'POST #create' do
    let(:item_params) { { quantity: 5, product: FactoryBot.build(:product) } }

    subject { post :create, params: item_params }

    context 'with valid attributes' do
      let(:item_params2) { { quantity: 4, product: FactoryBot.build(:product) } }
      it 'returns http created' do
        subject
        expect(response).to have_http_status(:created)
      end

      it 'create new item' do
        expect { post :create, params: item_params2 }.to change(Item, :count).by(1)
      end
      it 'returns json with all items and discounts' do
        subject
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(['items', 'discounts'])
        expect(json_response['items'].length).to eq(1)
      end
    end

    context 'with invalid attributes' do
      # it "doesn't create new article" do
      #   expect do
      #     post :create, params: { article: {
      #       title: nil,
      #       body: nil
      #       # photo: nil
      #     } }
      #   end .to_not change { Article.count }
      # end
      #
      # it 're-renders the new method' do
      #   post :create, params: { article: {
      #     title: nil,
      #     body: nil
      #     # photo: nil
      #   } }
      #   expect(response).to render_template :new
      # end
    end
  end

end
