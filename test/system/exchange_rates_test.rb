require "application_system_test_case"

class ExchangeRatesTest < ApplicationSystemTestCase
  setup do
    @exchange_rate = exchange_rates(:one)
  end

  test "visiting the index" do
    visit exchange_rates_url
    assert_selector "h1", text: "Exchange Rates"
  end

  test "creating a Exchange rate" do
    visit exchange_rates_url
    click_on "New Exchange Rate"

    fill_in "Date", with: @exchange_rate.date
    fill_in "From", with: @exchange_rate.from
    fill_in "Institution", with: @exchange_rate.institution_id
    fill_in "Rate", with: @exchange_rate.rate
    fill_in "To", with: @exchange_rate.to
    click_on "Create Exchange rate"

    assert_text "Exchange rate was successfully created"
    click_on "Back"
  end

  test "updating a Exchange rate" do
    visit exchange_rates_url
    click_on "Edit", match: :first

    fill_in "Date", with: @exchange_rate.date
    fill_in "From", with: @exchange_rate.from
    fill_in "Institution", with: @exchange_rate.institution_id
    fill_in "Rate", with: @exchange_rate.rate
    fill_in "To", with: @exchange_rate.to
    click_on "Update Exchange rate"

    assert_text "Exchange rate was successfully updated"
    click_on "Back"
  end

  test "destroying a Exchange rate" do
    visit exchange_rates_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Exchange rate was successfully destroyed"
  end
end
