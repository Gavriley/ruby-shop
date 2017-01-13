# top-level class documentation comment
class CommentsController < ApplicationController
  load_and_authorize_resource :product
  load_and_authorize_resource :comment, through: :product, singleton: true

  before_action :set_product, only: [:create, :update, :destroy, :modal]
  before_action :set_comment, only: [:update, :destroy, :modal]

  def create
    @comment = Comment.new(comment_params)
    @comment.product = @product
    @comment.user = current_user
    flash[:notice] = 'Коментар успішно добавлений' if @comment.save

    render :create, format: :js
  end

  def modal
    render :modal, format: :js
  end

  def update
    @comment.update(comment_params)
    render :update, format: :js
  end

  def destroy
    @comment.destroy
    render :destroy, format: :js
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end
end
