require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }

  before { host! 'api.taskmanager.test' }

  describe 'GET /users/:id' do 
    before do 
      headers = { 'Accept' => 'applicaton/vnd.taskmanager.v1' }
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when user exists' do 
      it "returns user" do 
        user_response = JSON.parse(response.body)
        expect(user_response['id']).to eql(user_id) 
      end

      it 'returns http status code 200' do 
        expect(response).to have_http_status(200)
      end
    end

    context 'when user not exist' do 
      let(:user_id) { 0 }
      
      it 'returns http status code 404' do 
        expect(response).to have_http_status(404)
      end
    end

  end

  describe 'POST /users' do
    before do 
      headers = { 'Accept' => "apllication/vnd.taskmanager.v1" }
      post '/users', params: {user: user_params}, headers: headers
    end
    
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      
      it 'return json data for the created user' do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eq(user_params[:email])
      end

      it 'return http status code 201' do 
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request params are invalid' do 
      let(:user_params) { attributes_for(:user, email: 'john@' ) }

      it 'return data json with key error' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end

      it 'return http status code 442' do 
        expect(response).to have_http_status(442)
      end

    end
    
  end

end