require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do 
  
  let!(:user) { create(:user) }
  let(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
		  'uid' => auth_data['uid'],
		  'client' => auth_data['client']
    }
  end

  before { host! 'api.taskmanager.test' }

  describe 'POST /auth/sign_in' do 
    before do 
      post '/auth/sign_in', params: credentials.to_json, headers: headers
    end
    
    context 'when the credentials are correct' do 
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns the authentication data in the headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end

      it 'returns http status code: OK' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the credentials are incorrects' do 
      let(:credentials) { {email: user.email, password: 'invalid_password'} }

      it 'returns tho json data with key errors' do
        expect(json_body).to have_key(:errors)
      end

      it 'return http status code: Unauthorized' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'DELETE /auth/sign_out' do 
    before do
      delete '/auth/sign_out', params: {}, headers: headers
    end
    
    it 'changes auth token the user' do
      user.reload
      expect( user.valid_token?(auth_data['access-token'], auth_data['client']) ).to eq(false)
    end

    it 'returns http status code: OK' do
      expect(response).to have_http_status(200)
    end
  end
end