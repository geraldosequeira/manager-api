require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  #it { is_expected.to validate_uniqueness_of(:email).case_insensitive } 
  it { is_expected.to allow_value('jhon@example.org').for(:email) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  
  describe '#generate_authentication_token!'do
    it 'generates a unique auth token' do
      token_default = '1a2b3c4d#'
      allow(Devise).to receive(:friendly_token).and_return(token_default)
      user.generate_authentication_token!

      expect(user.auth_token).to eq(token_default)
    end

    it 'generates another auth token when the current auth token already has been token' do
      allow(Devise).to receive(:friendly_token).and_return('a12bCyW#', 'a12bCyW#', '!a12bCyW#')
      old_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(old_user.auth_token)
    end
  end
  
  it { is_expected.to have_many(:tasks).dependent(:destroy) }

end
