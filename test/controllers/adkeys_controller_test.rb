require 'test_helper'

class AdkeysControllerTest < ActionDispatch::IntegrationTest
  setup do
    @adkey = adkeys(:one)
  end

  test "should get index" do
    get adkeys_url
    assert_response :success
  end

  test "should get new" do
    get new_adkey_url
    assert_response :success
  end

  test "should create adkey" do
    assert_difference('Adkey.count') do
      post adkeys_url, params: { adkey: { key: @adkey.key, shop_id: @adkey.shop_id } }
    end

    assert_redirected_to adkey_url(Adkey.last)
  end

  test "should show adkey" do
    get adkey_url(@adkey)
    assert_response :success
  end

  test "should get edit" do
    get edit_adkey_url(@adkey)
    assert_response :success
  end

  test "should update adkey" do
    patch adkey_url(@adkey), params: { adkey: { key: @adkey.key, shop_id: @adkey.shop_id } }
    assert_redirected_to adkey_url(@adkey)
  end

  test "should destroy adkey" do
    assert_difference('Adkey.count', -1) do
      delete adkey_url(@adkey)
    end

    assert_redirected_to adkeys_url
  end
end
