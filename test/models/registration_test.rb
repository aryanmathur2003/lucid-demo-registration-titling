require "test_helper"

class RegistrationTest < ActiveSupport::TestCase
  test "a California registration is valid and gets a temp tag" do
    registration = build_registration
    assert registration.save
    assert_equal "CA-T000001", registration.temp_tag.tag_number
  end

  test "an unknown state is rejected" do
    assert_not build_registration(state: "ZZ").valid?
  end
end
