class Registration < ApplicationRecord
  JURISDICTIONS = %w[CA TX NY ON].freeze
  STATUSES = %w[draft submitted on_hold completed].freeze

  # Documents every jurisdiction needs. The extra ones are added below.
  BASE_DOCUMENTS = %w[bill_of_sale proof_of_insurance odometer_statement].freeze

  has_one :temp_tag, dependent: :destroy
  has_many :lien_filings, dependent: :destroy

  serialize :documents, coder: JSON

  before_validation :normalize
  validates :vin, presence: true, uniqueness: true, length: { is: 17 }
  validates :buyer_name, presence: true
  validates :state, inclusion: { in: JURISDICTIONS }
  validates :status, inclusion: { in: STATUSES }
  validates :sale_price_cents, numericality: { only_integer: true, greater_than: 0 }

  after_create :issue_temp_tag

  def documents
    super || []
  end

  def required_documents
    docs = BASE_DOCUMENTS.dup
    docs << "smog_exemption_form" if state == "CA"
    docs << "form_130_u" if state == "TX"
    if state == "NY"
      docs << "form_mv_82"
      docs << "sales_tax_form_dtf_802" unless trade_in
    end
    if state == "ON"
      docs << "safety_standards_certificate"
      docs.delete("odometer_statement")
    end
    docs << "lien_agreement" if financed && state != "TX"
    docs
  end

  def missing_documents
    required_documents - documents
  end

  # Moves a draft to submitted, or to on_hold when paperwork is missing.
  def submit!
    raise "already #{status}" unless status == "draft"

    self.fee_cents = FeeCalculator.new(self).total_cents
    if missing_documents.any?
      self.status = "on_hold"
    else
      self.status = "submitted"
      self.submitted_at = Time.current
    end
    save!
    self
  end

  private

  def normalize
    self.vin = vin.to_s.strip.upcase
    self.state = state.to_s.strip.upcase
    self.state = "ON" if state == "ONT"
  end

  def issue_temp_tag
    # Ontario buyers get a temporary permit at the counter, not from us.
    return if state == "ON"

    TempTag.issue_for(self)
  end
end
