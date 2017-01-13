# top-level class documentation comment
class CategoriesController < ApplicationController
  before_action :set_category, only: :show

  load_and_authorize_resource

  def show
    @title = "Категорія: #{@category.name}"
    @products = @category.category_products
  end

  private

  def set_category
    @category = Category.includes(:products).find(params[:id])
  end
end
