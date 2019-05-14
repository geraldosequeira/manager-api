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

 end