require "test_helper"

class LienNoticeParserTest < ActiveSupport::TestCase
  test "reads a lender notice" do
    notice = LienNoticeParser.parse(file_fixture("lien_notice.xml").read)
    assert_equal "5LDEMAA0000000001", notice.vin
    assert_equal "Sample Credit Union", notice.lienholder_name
    assert_equal 4_500_000, notice.amount_cents
  end
end
