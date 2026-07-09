class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :expenses, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true

  # Default starter categories seeded for a brand-new user. Whole dollars,
  # no cents. Editable later.
  DEFAULT_CATEGORIES = [
    { name: "Groceries",     emoji: "🛒", color: "#16a34a", budget_amount: 200, period: "weekly" },
    { name: "Eating out",    emoji: "🍔", color: "#f97316", budget_amount: 100, period: "weekly" },
    { name: "Transport",     emoji: "🚗", color: "#0ea5e9", budget_amount: 60,  period: "weekly" },
    { name: "Fun",           emoji: "🎉", color: "#a855f7", budget_amount: 75,  period: "weekly" },
    { name: "Bills",         emoji: "💡", color: "#eab308", budget_amount: 300, period: "monthly" },
    { name: "Subscriptions", emoji: "📺", color: "#ef4444", budget_amount: 50,  period: "monthly" },
    { name: "Shopping",      emoji: "🛍️", color: "#ec4899", budget_amount: 150, period: "monthly" }
  ].freeze

  # Display name, falling back to the local part of the email address.
  def display_name
    name.presence || email_address.split("@").first
  end

  def initials
    display_name.split(/[\s@._-]/).reject(&:blank?).first(2).map { |part| part[0] }.join.upcase
  end

  def add_default_categories!
    DEFAULT_CATEGORIES.each_with_index do |attrs, index|
      categories.create!(attrs.merge(position: index))
    end
  end
end
