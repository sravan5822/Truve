class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_comment]
  before_action :verify_create_params, only: [:create]
  before_action :verify_update_params, only: [:update]


  # GET /products
  # GET /products.json
  def index
    user_id = params[:user_id]
    filter  = params[:filter]

    if filter
      if user_id.nil?
        raise "User_id param missing"
      end
    end

    if user_id
      if filter.nil?
        raise "Filter param missing"
      end
    end

    filter = filter || 'all'
    user   = User.find user_id if user_id

    case filter
      when 'all'
        @products = Product.all
      when 'friends'
        friend_ids = user.friends.map { |u| u.id }
        @products = Product.where user_id: friend_ids
      when 'friends_of_friends'
        friend_ids = user.friends.map { |u| u.id }
        friends_of_friends = user.friends_of_friends.map { |u| u.id }
        friends_of_friends = friends_of_friends - friend_ids
        total = (friends_of_friends).uniq
        @products = Product.where user_id: total
    end

    @products
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  def verify_create_params
    # params = ActiveSupport::JSON.decode(request.body.read).inspect
    missing = []
    required = ['title', 'description', 'price', 'brand', 'condition', 'user_id']
    required.each do |param|
      missing << param unless params.keys.include? param
    end

    unless missing.empty?
      e = { error: "Missing required fields: #{missing.join(', ')}" }
      render json: e
    end
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.image_ids = params[:image_ids].split(",") unless params[:image_ids].nil?

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { render action: 'new' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def verify_update_params
    # params = ActiveSupport::JSON.decode(request.body.read).inspect
    missing = []
    required = []
    required.each do |param|
      missing << param unless params.keys.include? param
    end

    unless missing.empty?
      e = { error: "Missing required fields: #{missing.join(', ')}" }
      render json: e
    end
  end

  def update
    @product.image_ids = params[:image_ids].split(",") unless params[:image_ids].nil?
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @product }
      else
        format.html { render action: 'edit' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def verify_add_comment
    # params = ActiveSupport::JSON.decode(request.body.read).inspect
    missing = []
    required = ['user_id', 'content']
    required.each do |param|
      missing << param unless params.keys.include? param
    end

    unless missing.empty?
      e = { error: "Missing required fields: #{missing.join(', ')}" }
      render json: e
    end
  end

  def add_comment
    @comment = Comment.new(comment_params)
    @comment.product_id = params[:id]

    respond_to do |format|
      if @comment.save
        @product.reload
        format.html { redirect_to @product, notice: 'Comment was successfully added.' }
        format.json { render action: 'show', status: :created, location: @product }
      else
        format.html { redirect_to @product, error: 'Comment could not be added.' }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end

    product_owner = @comment.product.user
    if product_owner.device_token
      begin
        APN_POOL.with do |connection|
          comment_content = if @comment.content.length > 80
                              @comment.content[0...80] + "..."
                            else
                              @comment.content
                            end

          notification  = Houston::Notification.new device: product_owner.device_token
          notification.alert = "New Comment:\n#{comment_content}"
          Rails.logger.info "*" * 88
          Rails.logger.info notification.inspect
          Rails.logger.info "-----"
          Rails.logger.info notification.message.inspect
          Rails.logger.info "-----"
          Rails.logger.info connection.inspect
          Rails.logger.info "*" * 88
          connection.write(notification.message)
        end
      rescue
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.permit(:title, :description, :price, :brand, :condition, :user_id)
    end

    def comment_params
      params.permit(:user_id, :product_id, :content)
    end
end
