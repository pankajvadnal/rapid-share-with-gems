class DocumentsController < ApplicationController
    before_action :authenticate_user!, except: [:public_show]

  def index
    @documents = current_user.documents
    @documents_count = @documents.count
  end

  def new
    @document = current_user.documents.new
  end

  def create
    @document = current_user.documents.new(document_params)

    begin
      if @document.save
        redirect_to documents_path, notice: 'File uploaded successfully.'
      else
        flash.now[:alert] = 'Error: Unable to save document.'
        render :new
      end
    rescue => e
      # Log the exception
      flash[:alert] = "Error: #{e.message}"
      redirect_to new_document_path
    end
  end

  def download
    @document = Document.find(params[:id])
    redirect_to rails_blob_path(@document.file, disposition: 'attachment')
  end

  def destroy
    @document = current_user.documents.find(params[:id])
    
    if @document.destroy
      # Purge the attached file upon successful deletion
      @document.file.purge if @document.file.attached?

      redirect_to documents_path, notice: 'File deleted successfully.'
    else
      flash[:alert] = 'Error: Unable to delete document.'
      redirect_to documents_path
    end
  end

  # Toggle the public_share attribute
  def toggle_public_share
    @document = current_user.documents.find(params[:id])

    if @document && @document.update_attribute(:public_share, !@document.public_share)
        redirect_to documents_path, notice: 'Public sharing status updated.'
    else
        flash[:alert] = 'Error: Unable to update public sharing status.'
        redirect_to documents_path, alert: 'Document not found.'
    end
  end

def public_show
    @document = Document.find_by(uuid: params[:uuid])

    if @document
      render :public_share
    else
      flash[:alert] = 'Document not found.'
      render plain: 'Document not found', status: :not_found
      # redirect_to root_path
    end
end

  private

  def document_params
    params.require(:document).permit(:name, :file, :upload_date, :public_share)
  end
end
