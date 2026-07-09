class DashboardController < ApplicationController
  def show
    @summary = BudgetSummary.new(current_user)
    @recent_expenses = current_user.expenses.recent.includes(:category).limit(8)
    @logged_today = current_user.expenses.where(spent_on: Date.current).exists?
  end
end
