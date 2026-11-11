# Works out what the buyer owes for registration and title.
class FeeCalculator
  TITLE_FEE_CENTS = { "CA" => 2_700, "TX" => 3_300, "NY" => 5_000, "ON" => 3_200 }.freeze
  EV_SURCHARGE_CENTS = { "CA" => 11_800, "TX" => 20_000 }.freeze

  def initialize(registration)
    @registration = registration
  end

  def total_cents
    title_fee_cents + registration_fee_cents + ev_surcharge_cents + lien_fee_cents
  end

  def title_fee_cents
    TITLE_FEE_CENTS.fetch(@registration.state)
  end

  def registration_fee_cents
    case @registration.state
    when "CA"
      # Flat fee plus a share of the sale price, capped.
      [7_400 + (@registration.sale_price_cents * 65 / 10_000), 250_000].min
    when "TX"
      5_075
    when "NY"
      # By weight, in 100 lb steps, with a floor.
      steps = (@registration.vehicle_weight_lbs / 100.0).ceil
      [steps * 110, 2_600].max
    when "ON"
      0
    end
  end

  def ev_surcharge_cents
    EV_SURCHARGE_CENTS.fetch(@registration.state, 0)
  end

  def lien_fee_cents
    return 0 unless @registration.financed

    @registration.state == "NY" ? 500 : 1_500
  end
end
