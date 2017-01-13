module Admin
  # top-level class documentation comment
  class ProductsController < Admin::AdminController
    before_action :set_product, only: :destroy

    def dashboard
      @title = 'Майстерня'

      @orders = Order.latest.first(3)
      @products = Product.latest.first(10)
    end

    def index
      @title = 'Товари'

      set_search_products

      respond_to do |format|
        format.html { render :index }
        format.js { render :products }
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def set_search_products
      if params[:search_product]
        @products = Product.search(params[:search_product]).latest.page(params[:page])
      else  
        @products = Product.latest.limit(20).page(params[:page])
      end  
    end
  end
end
