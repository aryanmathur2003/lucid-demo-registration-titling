ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  def build_registration(**attrs)
    Registration.new({
      vin: "5LDEMAA0000000001",
      state: "CA",
      buyer_name: "Sample Buyer",
      sale_price_cents: 7_990_000
    }.merge(attrs))
  end
end
