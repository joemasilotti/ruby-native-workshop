class SummaryController < ApplicationController
  def show
    @history = SpendingHistory.new(current_user)
  end
end
