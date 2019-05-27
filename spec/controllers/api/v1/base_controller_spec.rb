require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  describe 'includes autheticable module' do
    it { expect(controller.class.ancestors).to include(Authenticable) } 
  end
end