require 'rails_helper'

RSpec.describe 'Sessions API', type: :request  do 
  before { host! 'api.taskmanager.test' }
  let(:user) { create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /sessions' do
    before do 
      post '/sessions', params: { session: credentials }.to_json, headers: headers
    end
    
    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns the json data of the user with auth token' do
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
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

  describe 'DELETE /sessions/:id' do
    before do
      delete "/sessions/#{user.auth_token}", params: {}, headers: headers
    end
    
    it 'changes auth token the user' do
      expect(User.find_by(auth_token: user.auth_token)).to be_nil
    end

    it 'returns http status code: No Content' do
      expect(response).to have_http_status(204)
    end
  end
end