class RegistrationsController < ApplicationController
  def create
    registration = Registration.new(registration_params)
    if registration.save
      render json: present(registration), status: :created
    else
      render json: { errors: registration.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: present(Registration.find(params[:id]))
  end

  def submit
    registration = Registration.find(params[:id])
    registration.submit!
    render json: present(registration)
  rescue RuntimeError => e
    render json: { error: e.message }, status: :conflict
  end

  # Lenders post an XML lien notice here.
  def lien_notice
    registration = Registration.find(params[:id])
    notice = LienNoticeParser.parse(request.raw_post)
    if notice.vin != registration.vin
      render json: { error: "vin does not match" }, status: :unprocessable_entity
      return
    end

    filing = registration.lien_filings.create!(
      lienholder_name: notice.lienholder_name,
      lienholder_code: notice.lienholder_code,
      amount_cents: notice.amount_cents
    )
    render json: { id: filing.id, status: filing.status, file_by: filing.file_by }, status: :created
  rescue LienNoticeParser::InvalidNotice => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def registration_params
    params.require(:registration).permit(
      :vin, :state, :buyer_name, :sale_price_cents, :vehicle_weight_lbs, :financed, :trade_in, documents: []
    )
  end

  def present(registration)
    {
      id: registration.id,
      vin: registration.vin,
      state: registration.state,
      status: registration.status,
      fee_cents: registration.fee_cents,
      required_documents: registration.required_documents,
      missing_documents: registration.missing_documents,
      temp_tag: registration.temp_tag&.slice(:tag_number, :issued_on, :expires_on)
    }
  end
end
