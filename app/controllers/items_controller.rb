class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all

    end
    render json: items, include: :user
  end

  def show
    items = Item.find(params[:id])
    items.user
    render json: items
  
  end
  
  def create
    if params[:user_id]
      user = User.find(params[:user_id])
      item = user.items.create(create_params)
    else
      item = Item.create(create_params)
      return render json: item, status: :created
    end
    render json: item, status: :created
  end
  
    private
    def render_not_found_response
      render json: { error: "Dog house not found" }, status: :not_found
    end
  
    def create_params
      params.permit(:name, :description, :price)
    end
  

end