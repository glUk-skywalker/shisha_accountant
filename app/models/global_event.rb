class GlobalEvent < ApplicationRecord
  scope :spendings, -> { where('`change` < 0') }
  scope :income, -> { where('`change` > 0') }

  def self.spendings_sum
    spendings.map(&:change).inject('+').abs
  end

  def self.income_sum
    income.map(&:change).inject('+')
  end
end
