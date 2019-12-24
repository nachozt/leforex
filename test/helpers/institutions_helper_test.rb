require 'test_helper'

class InstitutionsHelperTest < ActionView::TestCase
  setup do
    # TODO: use factories
    @institution = Institution.create(name: 'Test Institution', fee: 0)
  end

  test "returns institution get_amount value if currency pair exists for institution" do
    amount = 10
    @institution.banko.add_rate('USD', 'CAD', 0.9)
    conversion_input = { from: "USD", to: "CAD", quantity: amount }

    ins_amount = @institution.get_amount('USD', 'CAD', amount)
    helper_amount = dynamic_amount(@institution, conversion_input)
    
    assert_equal number_to_currency(ins_amount), helper_amount
  end

  test "returns interrogation mark if currency pair exists for institution" do
    amount = 10
    conversion_input = { from: "USD", to: "CAD", quantity: amount }
    helper_amount = dynamic_amount(@institution, conversion_input)
    
    assert_equal "?", helper_amount
  end
end
