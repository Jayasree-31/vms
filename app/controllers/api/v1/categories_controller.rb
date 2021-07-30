class Api::V1::CategoriesController < Api::BaseController

  # GET /categories
  def index
    @categories = Category.all
  end
end
