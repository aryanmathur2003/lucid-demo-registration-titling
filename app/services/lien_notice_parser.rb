require "rexml/document"

# Reads the XML lien notice a lender sends when a vehicle is financed.
class LienNoticeParser
  class InvalidNotice < StandardError; end

  Result = Struct.new(:vin, :lienholder_name, :lienholder_code, :amount_cents, keyword_init: true)

  def self.parse(xml)
    new(xml).parse
  end

  def initialize(xml)
    @xml = xml.to_s
  end

  def parse
    doc = REXML::Document.new(@xml)
    root = doc.root
    raise InvalidNotice, "missing LienNotice element" unless root&.name == "LienNotice"

    Result.new(
      vin: text_at(root, "Vehicle/VIN").upcase,
      lienholder_name: text_at(root, "Lienholder/Name"),
      lienholder_code: root.elements["Lienholder"]&.attributes&.[]("code"),
      amount_cents: to_cents(text_at(root, "Amount"))
    )
  rescue REXML::ParseException => e
    raise InvalidNotice, e.message
  end

  private

  def text_at(root, path)
    value = root.elements[path]&.text.to_s.strip
    raise InvalidNotice, "missing #{path}" if value.empty?

    value
  end

  def to_cents(amount)
    (BigDecimal(amount) * 100).to_i
  rescue ArgumentError
    raise InvalidNotice, "invalid Amount"
  end
end
