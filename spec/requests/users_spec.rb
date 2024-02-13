require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    let(:user) { create(:user) }
    let(:token) { auth_token_for_user(user) }

    before do
      user
      get "/users", headers: { Authorization: "Bearer #{token}" }
    end
    
    it 'returns a sucessful response' do
      expect(response).to be_successful
    end

    it 'returns a response with all the users' do
      expect(response.body).to eq(User.all.to_json)
    end
  end

  # show
  describe "GET /post/:id" do
    let(:user) { create(:user) }
    let(:token) { auth_token_for_user(user) }

    before do
      get "/users/#{user.id}", headers: { Authorization: "Bearer #{token}" }
    end

    it 'returns a sucessful response' do
      expect(response).to be_successful
    end

    it 'returns a response with the correct user' do
      expect(response.body).to eq(user.to_json)
    end
  end

  # create
  describe 'POST /users' do
    context 'with valid params' do

      before do
        user_attributes = attributes_for(:user)
        post '/users', params: user_attributes
      end

      it 'returns a sucessful response' do
        expect(response).to be_successful
      end

      it 'creates a new user' do
        expect(User.count).to eq(1)
      end
    end

    context 'with invalid params' do

      before do
        user_attributes = attributes_for(:user, first_name: nil)
        post '/users', params: user_attributes
      end

      it 'returns a response with errors' do
        expect(response.status).to eq(422)
      end
    end
  end

  # update
  describe "PUT /users/:id" do
    context 'with valid params' do
      let(:user) { create(:user) }
      let(:token) { auth_token_for_user(user) }

      before do
        user_attributes = attributes_for(:user, first_name: "John")
        put "/users/#{user.id}", params: user_attributes, headers: { Authorization: "Bearer #{token}" }
      end

      it 'updates a user' do
        user.reload
        expect(user.first_name).to eq('John')
      end

      it 'returns a sucessful response' do
        expect(response).to be_successful
      end
    end

    context 'with invalid params' do
      let(:user) { create(:user) }
      let(:token) { auth_token_for_user(user) }
      
      before do
        user_attributes = { first_name: nil }
        put "/users/#{user.id}", params: user_attributes, headers: { Authorization: "Bearer #{token}" }
      end

      it 'returns a response with errors' do
        expect(response.status).to eq(422)
      end
    end
  end

  # destroy

  describe 'DELETE /user/:id' do
    let(:user) { create(:user) }
    let(:token) { auth_token_for_user(user) }

    before do
      delete "/users/#{user.id}", headers: { Authorization: "Bearer #{token}" }
    end

    it 'deletes a user' do
      expect(User.count).to eq(0)
    end

    it 'returns a successful response' do
      expect(response).to be_successful
    end
  end
end
