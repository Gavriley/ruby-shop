module Admin
  # top-level class documentation comment
  class CommentsController < Admin::AdminController
    before_action :set_comment, only: [:modal, :update, :destroy]

    def index
      @title = 'Список відгуків'
      set_comments

      respond_to do |format|
        format.html { render :index }
        format.js { render :comments }
      end
    end

    def modal
      set_comments
      render :comment_modal, format: :js
    end

    def update
      @comment.update(comment_params)
      set_comments
      render :update, format: :js
    end

    def destroy
      @comment.destroy
      set_comments
      redirect_to admin_comments_path
    end

    private

    def comment_params
      params.require(:comment).permit(:content)
    end

    def set_comments
      @comments = Comment.latest.page(params[:page])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
  end
end
