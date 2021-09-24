require 'rails_helper'

RSpec.describe 'Welcome', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get root_path
      expect(response.body).to match(/Welcome*/)
    end
  end
end
