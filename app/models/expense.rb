class Expense < ApplicationRecord
  belongs_to :category
  belongs_to :user

  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  validates :spent_on, presence: true
  validate :category_belongs_to_user

  before_validation :apply_defaults

  scope :between, ->(range) { where(spent_on: range) }
  scope :recent, -> { order(spent_on: :desc, created_at: :desc) }

  private

  def apply_defaults
    self.spent_on ||= Date.current
  end

  def category_belongs_to_user
    return if category.nil? || user_id.nil?
    errors.add(:category, "is not one of yours") if category.user_id != user_id
  end
end
