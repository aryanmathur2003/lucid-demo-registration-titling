class LienFiling < ApplicationRecord
  belongs_to :registration

  validates :lienholder_name, presence: true
  validates :amount_cents, numericality: { only_integer: true, greater_than: 0 }
  validates :status, inclusion: { in: %w[pending filed rejected] }

  before_create :set_file_by

  private

  # How long we have to file the lien after the registration is created.
  def set_file_by
    window =
      case registration.state
      when "CA" then 10
      when "TX" then 30
      when "NY" then 10
      when "ON" then 15
      end
    self.file_by ||= registration.created_at.to_date + window
  end
end
