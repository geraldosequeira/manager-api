require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do #HUAhuHUAhUHauHUahUHa
  
  before { host! 'api.taskmanager.test' }

  let!(:user) { create(:user) }

  let(:headers) do 
    {
      'Content-Type' => Mime[:json].to_s,
      'Accept' => 'apllication/vnd.taskmanager.v1',
      'Authorization' => user.auth_token
    }
  end

  describe 'GET /tasks' do
    before do
      create_list(:task, 5, user: user)
      get "/tasks", params: {}, headers: headers
    end

    it 'returns tasks of user' do
      expect(json_body[:tasks].count).to eq(5)
    end

    it 'returns http status code: OK ' do
      expect(response).to have_http_status(200)
    end
  end

end