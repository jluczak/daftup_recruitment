# frozen_string_literal: true

require 'test_helper'

class TotalsControllerTest < ActionDispatch::IntegrationTest
  test 'should get show' do
    get totals_show_url
    assert_response :success
  end
end
