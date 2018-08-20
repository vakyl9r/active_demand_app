require "application_system_test_case"

class AdkeysTest < ApplicationSystemTestCase
  setup do
    @adkey = adkeys(:one)
  end

  test "visiting the index" do
    visit adkeys_url
    assert_selector "h1", text: "Adkeys"
  end

  test "creating a Adkey" do
    visit adkeys_url
    click_on "New Adkey"

    fill_in "Key", with: @adkey.key
    fill_in "Shop", with: @adkey.shop_id
    click_on "Create Adkey"

    assert_text "Adkey was successfully created"
    click_on "Back"
  end

  test "updating a Adkey" do
    visit adkeys_url
    click_on "Edit", match: :first

    fill_in "Key", with: @adkey.key
    fill_in "Shop", with: @adkey.shop_id
    click_on "Update Adkey"

    assert_text "Adkey was successfully updated"
    click_on "Back"
  end

  test "destroying a Adkey" do
    visit adkeys_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Adkey was successfully destroyed"
  end
end
