require 'rails_helper'

RSpec.describe DocumentsController, type: :controller do
  let(:user) { create(:user) }
  let(:document) { create(:document, user: user) }

  describe 'GET #index' do
    it 'assigns @documents and @documents_count' do
      get :index
      expect(assigns(:documents)).to eq([document])
      expect(assigns(:documents_count)).to eq(1)
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'assigns @document' do
      get :new
      expect(assigns(:document)).to be_a_new(Document)
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Document' do
        expect {
          post :create, params: { document: attributes_for(:document) }
        }.to change(Document, :count).by(1)
      end

      it 'redirects to documents_path' do
        post :create, params: { document: attributes_for(:document) }
        expect(response).to redirect_to(documents_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      it 'renders the new template' do
        post :create, params: { document: attributes_for(:document, name: '') }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to be_present
      end
    end

    context 'with exception during save' do
      it 'redirects to new_document_path with an alert' do
        allow_any_instance_of(Document).to receive(:save).and_raise('Custom save error')
        post :create, params: { document: attributes_for(:document) }
        expect(response).to redirect_to(new_document_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #download' do
    it 'redirects to the document file' do
      get :download, params: { id: document.id }
      expect(response).to redirect_to(rails_blob_path(document.file, disposition: 'attachment'))
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested document' do
      expect {
        delete :destroy, params: { id: document.id }
      }.to change(Document, :count).by(-1)
      expect(response).to redirect_to(documents_path)
      expect(flash[:notice]).to be_present
    end

    context 'with exception during destroy' do
      it 'redirects to documents_path with an alert' do
        allow_any_instance_of(Document).to receive(:destroy).and_raise('Custom destroy error')
        delete :destroy, params: { id: document.id }
        expect(response).to redirect_to(documents_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #toggle_public_share' do
    it 'toggles the public_share attribute' do
      patch :toggle_public_share, params: { id: document.id }
      document.reload
      expect(document.public_share).to eq(!document.public_share)
      expect(response).to redirect_to(documents_path)
      expect(flash[:notice]).to be_present
    end

    context 'when document is not found' do
      it 'redirects to documents_path with an alert' do
        patch :toggle_public_share, params: { id: 'nonexistent_id' }
        expect(response).to redirect_to(documents_path)
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'GET #public_show' do
    it 'renders the public_share template' do
      get :public_show, params: { uuid: document.uuid }
      expect(response).to render_template(:public_share)
    end

    context 'when document is not found' do
      it 'renders plain text "Document not found" with status :not_found' do
        get :public_show, params: { uuid: 'nonexistent_uuid' }
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('Document not found')
        expect(flash[:alert]).to be_present
      end
    end
  end
end
