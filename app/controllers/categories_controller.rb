class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ edit update destroy ]

  def index
    @categories = current_user.categories.ordered
  end

  def new
    @category = current_user.categories.new(
      period: Category::PERIODS.include?(params[:period]) ? params[:period] : "weekly",
      color: Category::COLORS.sample
    )
  end

  def create
    @category = current_user.categories.new(category_params)
    if @category.save
      redirect_to settings_path, notice: "Added #{@category.name}."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to settings_path, notice: "Updated #{@category.name}."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to settings_path, notice: "Removed #{@category.name}.", status: :see_other
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def category_params
    params.expect(category: [ :name, :emoji, :color, :budget_amount, :period ])
  end
end
