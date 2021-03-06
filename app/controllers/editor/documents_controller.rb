class Editor::DocumentsController < EditorController
  before_action :find_document, only: [:show, :update, :destroy]

  def show
    cookies.permanent.signed[:last_visited_document] = @document.to_param
  end

  def index
    if param = cookies.signed[:last_visited_document]
      decoded_id = MaskedId.decode(:document, param)
      if document = current_user.documents.find_by(id: decoded_id)
        redirect_to editor_document_path(document) and return
      end
    end

    if document = current_user.last_updated_document
      redirect_to editor_document_path(document) and return
    end
  end

  def create
    @document = Document.new(document_params)
    @document.stack = current_user.root_stack

    if @document.save
      redirect_to editor_document_path(@document)
    else
      redirect_to editor_documents_path
    end
  end

  def update
    @document.update(document_params)
    redirect_to editor_documents_path
  end

  def destroy
    @document.transaction do
      @document.bookmarks.destroy_all
      @document.destroy
    end

    redirect_to editor_documents_path
  end

  private

  def find_document
    decoded_id = MaskedId.decode(:document, params[:id])
    return if @document = current_user.documents.find(decoded_id)
    raise ApplicationController::NotAuthorized
  end

  def document_params
    params.require(:document).permit(:name)
  end
end
