class SettingsController < ApplicationController
  def show
    @categories = current_user.categories.ordered
  end
end
