module Admin
  # top-level class documentation comment
  class CategoriesController < Admin::AdminController
    skip_before_filter :verify_authenticity_token
    before_action :set_category, only: [:destroy, :modal, :update]

    def index
      @title = 'Список категорій'
      set_categories
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      @category.save
      category_response 'Категорія успішно добавлена'
    end

    def destroy
      @category.destroy
      category_response 'Категорія успішно видалена'
    end

    def modal
      set_categories
      render :modal, format: :js
    end

    def update
      (flash[:alert] = 'Категорія успішно оновлена') && set_categories if @category.update(category_params)
      render :update, format: :js
    end

    private

    def category_response(message)
      set_categories
      flash[:alert] = message
      render :category, format: :js
    end

    def category_params
      params.require(:category).permit(:name, :parent_id)
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def set_categories
      @categories = Category.includes(:children).where(parent_id: 0).order(id: :desc)
    end
  end
end
