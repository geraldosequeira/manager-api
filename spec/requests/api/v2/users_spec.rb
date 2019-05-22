require 'rails_helper'

RSpec.describe 'Users API', type: :request do 
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Authorization' => "#{user.auth_token}",
      'Content-Type' => Mime[:json].to_s
    }
  end

  before { host! 'api.taskmanager.test' }

  describe 'GET /users/:id' do 
    before do 
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when user exists' do 
      it "returns user" do 
        expect(json_body[:data][:id].to_i).to eql(user_id) 
      end

      it 'returns http status code: OK' do 
        expect(response).to have_http_status(200)
      end
    end

    context 'when user not exist' do 
      let(:user_id) { 0 }
      
      it 'returns http status code: Not Found' do 
        expect(response).to have_http_status(404)
      end
    end

  end

  describe 'POST /users' do
    before do 
      post '/users', params: { user: user_params }.to_json, headers: headers
    end
    
    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }
      
      it 'return json data for the created user' do 
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
      end

      it 'return http status code: Created' do 
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request params are invalid' do 
      let(:user_params) { attributes_for(:user, email: 'john@' ) }

      it 'return data json with key error' do 
        expect(json_body).to have_key(:errors)
      end

      it 'return http status code: Unprocessable Entity' do 
        expect(response).to have_http_status(442)
      end

    end
    
  end

  describe 'PUT /users/:id' do
    before do
      put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
    end
    
    context 'when the request parms are valid' do
      let(:user_params) { { email: 'e-mail@email.org' } }

      it 'returns the json data for the updated user' do 
        expect(json_body[:data][:attributes][:email]).to eq(user_params[:email]) 
      end

      it 'return http status code: OK' do 
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { {email: 'jhon@'} } 

      it 'returns http status code: Unprocessable Entity' do 
        expect(response).to have_http_status(442)
      end

      it 'returns the json data with key errors' do 
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end
    
    it 'returns http status code: No Content' do 
      expect(response).to have_http_status(204)
    end

    it 'No find user in database' do 
      expect(User.find_by(id: user_id)).to be_nil
    end
  end

end