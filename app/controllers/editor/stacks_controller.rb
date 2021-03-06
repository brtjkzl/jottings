class Editor::StacksController < EditorController
  before_action :find_stack, only: [:destroy, :update]
  before_action :require_ownership, only: [:destroy, :update]

  def create
    @stack = Stack.new(stack_params)
    @stack.assign_to(current_user)
    @stack.save

    redirect_to editor_document_path(@stack.documents.last)
  end

  def update
    @stack.update(stack_params)
    redirect_to editor_documents_path
  end

  def destroy
    @stack.destroy
    redirect_to editor_documents_path
  end

  private

  def stack_params
    params.require(:stack).permit(:name, collaborations_attributes: [:email])
  end

  def find_stack
    decoded_id = MaskedId.decode(:stack, params[:id])
    @stack = current_user.stacks.find(decoded_id)
  end

  def require_ownership
    raise ApplicationController::NotAuthorized unless @stack.owner?(current_user)
  end
end
