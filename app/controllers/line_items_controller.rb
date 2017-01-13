# top-level class documentation comment
class LineItemsController < ApplicationController
  include CurrentCart

  load_and_authorize_resource
  skip_before_filter :verify_authenticity_token
  before_action :set_cart
  before_action :set_line_item, only: [:count_up, :count_down, :destroy]

  def count_up
    @line_item.count += 1
    @line_item.save

    render :count, format: :js
  end

  def count_down
    @line_item.count -= 1
    @line_item.save

    if @line_item.count > 0
      render :count, format: :js
    else
      @line_item.destroy
      check_cart && return
      render :destroy, format: :js
    end
  end

  def create
    if params[:count].present? && (params[:count].to_i > 1)
      @line_item = @cart.add_products(params[:product_id], params[:count].to_i).save
    else
      @line_item = @cart.add_products(params[:product_id]).save
    end

    render :create, format: :js
  end

  def destroy
    @line_item.destroy
    check_cart && return

    render :destroy, format: :js
  end

  private

  def check_cart
    if @cart.line_items.empty?
      @cart.destroy && cookies.delete(:cart_id)
      redirect_to(root_path, notice: 'Корзина пуста') && (return true)
    end
  end

  def set_line_item
    @line_item = @cart.line_items.find(params[:id])
  end
end
