class Store::ProductsController < ApplicationController
  before_action :set_product, only: [:edit, :update, :show, :destroy, :toggle_display]

  def index
    @products = Store::Product.all
  end

  def new
    @product = Store::Product.new
  end

  def create
    @product = Store::Product.new(product_params)
    if @product.save
      update_images
      flash[:notice] = "已建立新商品：#{@product.title}"
      redirect_to store_products_path
    else
      render :new
    end
  end

  def edit
    set_attached_images
  end

  def update
    if @product.update(product_params)
      update_images
      update_prices(@product.id)
      flash[:notice] = "已更新商品內容"
      redirect_to store_products_path
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    @product.delete
    flash[:notice] = "產品已刪除"
    redirect_to store_products_path
  end
  
  def toggle_display
    if @product.display
      @product.update_column(:display, false)
    else
      @product.update_column(:display, true)
    end
    render json: @product.display
  end

  def add_to_cart
    return if not quantity_valid(params[:quantity])
    order = find_current_order || find_or_create_new_order
    result = order.add_item(params[:product_id], params[:quantity].to_i)
    order.update_total_price
    place = order.aasm_state == "cart" ? "購物車" : "訂單"
    flash[:notice] = "已加入#{place}：#{result[:title]}"
    redirect_to request.referer
  end

  private
    def set_product
      @product = Store::Product.includes(:images).find(params[:id])
    end

    def product_params
      params.require(:store_product).permit(:title, :description, :stock, :price, :default_image, :category_id, :display)
    end

    def update_images
      new_images = [1,2,3,4,5].map {|n| params[:store_product]["image_#{n}".to_sym] }
      @product.update_images(new_images)
    end

    def set_attached_images
      images = @product.images.limit(5).map(&:image)
      images.each do |image|
        index = images.index(image)+1
        @product.send("image_#{index}=", image)
      end
    end

    def quantity_valid(quantity)
      if quantity.to_i < 1
        flash[:alert] = "請填入數字並確認數量大於 1"
        redirect_to :back
        return false
      end
      return true
    end

    def update_prices(id)
      Store::Order.includes(:items => [:product]).unpaid.each {|order| order.update_item_price(id) }
    end
end
