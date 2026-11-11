class TempTag < ApplicationRecord
  belongs_to :registration

  validates :tag_number, :issued_on, :expires_on, presence: true

  def self.issue_for(registration, issued_on: Date.current)
    days =
      case registration.state
      when "CA" then 90
      when "TX" then registration.financed ? 60 : 30
      when "NY" then 30
      else 30
      end

    expires = issued_on + days
    # New York tags may not expire on a Sunday. Push to Monday.
    expires += 1 if registration.state == "NY" && expires.sunday?

    create!(
      registration: registration,
      tag_number: "#{registration.state}-T#{registration.vin.last(6)}",
      issued_on: issued_on,
      expires_on: expires
    )
  end

  def expired?(on: Date.current)
    on > expires_on
  end
end
