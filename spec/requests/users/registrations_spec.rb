require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  
  # Include Devise test helpers
  include Devise::Test::ControllerHelpers

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: { username: 'usernametest', name: 'fname lname', email: 'test@example.com', password: 'passwordtest' } }
        }.to change(User, :count).by(1)
      end

      it 'redirects to the root path' do
        post :create, params: { user: { username: 'usernametest', name: 'fname lname', email: 'test@example.com', password: 'passwordtest' } }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post :create, params: { user: { username: 'usernametest', name: 'fname lname', email: '', password: '' } }
        }.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: { username: 'usernametest', name: 'fname lname', email: '', password: '' } }
        expect(response).to render_template(:new)
      end
    end
  end
end
