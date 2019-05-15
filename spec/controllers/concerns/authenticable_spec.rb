require 'rails_helper'

 RSpec.describe Authenticable do
  
  controller(ApplicationController) do
    include Authenticable
  end

  let(:genereic_controller) { subject }

  describe '#current_user' do
    let(:user) { create(:user) }

    before do
      request_mok = double(:headers => { 'Authorization' => user.auth_token } )
      allow(genereic_controller).to receive(:request).and_return(request_mok)
    end
  
    it 'returns the user from the authorization header' do
      expect(genereic_controller.current_user).to eql(user)
    end
  end

  describe '#authenticate_with_token!' do
    controller do
      before_action :authenticate_with_token!
      def protected_action; end
    end
   
    context 'when there is no user logged in' do

      before do
        allow(genereic_controller).to receive(:current_user).and_return(nil)
        routes.draw { get 'protected_action' => 'anonymous#protected_action' }
        get :protected_action
      end

      it 'returns data json with errors key' do
        expect(json_body).to have_key(:errors)
      end

      it 'returns http status code: Unauthorized' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe '#user_logged_in?' do
    context 'when there is a user logged in' do 
      before do 
        user = create(:user)
        allow(genereic_controller).to receive(:current_user).and_return(user)
      end

      it { expect(genereic_controller.user_logged_in?).to be true }
    end

    context 'when there is no user logged in' do
      before do 
        allow(genereic_controller).to receive(:current_user).and_return(nil)
      end
      
      it { expect(genereic_controller.user_logged_in?).to be false }
    end
  end
end