require 'test_helper'

class InstitutionTest < ActiveSupport::TestCase
  setup do
    # TODO: use factories
    @institution = Institution.create(name: 'Test Institution', fee: 0)
    Money.default_bank = @institution.banko
  end

  #
  # describe banko
  #
  test "when called once returns an instance of Money::Bank::VariableExchange" do
    assert_instance_of Money::Bank::VariableExchange, @institution.banko
  end

  test "when called more than once returns the same instance of Money::Bank::VariableExchange" do
    banko0 = @institution.banko
    banko1 = @institution.banko
    assert_equal banko0, banko1
  end

  #
  # describe add_rate
  #
  test "can add_rate through Money.default_bank" do
    assert_difference 'ExchangeRate.count' do
      @institution.banko.add_rate('USD', 'CAD', 0.9)
    end
  end

  test "updates rate when currency pair already existis for institution" do
    @institution.banko.add_rate('USD', 'CAD', 0.9)
    new_rate = 0.8
    assert_no_difference 'ExchangeRate.count' do
      @institution.banko.add_rate('USD', 'CAD', new_rate)
      assert_equal new_rate, @institution.banko.get_rate('USD', 'CAD')
    end
  end

  test "same currency pair cannot be created for the same institution" do
    assert_difference 'ExchangeRate.count' do
      @institution.banko.add_rate('USD', 'CAD', 0.9)
    end
    assert_no_difference 'ExchangeRate.count' do
      @institution.banko.add_rate('USD', 'CAD', 0.9)
    end
  end

  test "same currency pair can be created for a different institution" do
    assert_difference 'ExchangeRate.count' do
      @institution.banko.add_rate('USD', 'CAD', 0.9)
    end
    
    other_institution = Institution.create(name: 'Test Institution', fee: 0)
    assert_difference 'ExchangeRate.count' do
      other_institution.banko.add_rate('USD', 'CAD', 0.9)
    end
  end

  #
  # describe get_rate
  #
  test "can get_rate" do
    new_rate = 0.9
    @institution.banko.add_rate('USD', 'CAD', new_rate)

    assert_equal new_rate, @institution.banko.get_rate('USD', 'CAD')
  end

  test "returns nil when currency pair does not exist" do
    assert_nil @institution.banko.get_rate('USD', 'CLP')
  end

  test "same currency pair for the same institution returns the same rate" do
    @institution.banko.add_rate('USD', 'CAD', 0.9)

    assert_equal @institution.banko.get_rate('USD', 'CAD'), @institution.banko.get_rate('USD', 'CAD')
  end

  test "same currency pair for the different institution returns the different rate" do
    @institution.banko.add_rate('USD', 'CAD', 0.9)
    first_ins_rate = @institution.banko.get_rate('USD', 'CAD')

    other_institution = Institution.create(name: 'Test Institution', fee: 0)
    other_institution.banko.add_rate('USD', 'CAD', 0.8)
    second_ins_rate = other_institution.banko.get_rate('USD', 'CAD')

    assert_not_equal first_ins_rate, second_ins_rate
  end

  #
  # describe get_amount
  #
  test "can convert amount" do
    @institution.banko.add_rate('USD', 'CLP', 750)

    converted_amount = @institution.get_amount('USD', 'CLP', 3)
    assert_equal 750 * 3, converted_amount.amount
  end

  test "returns nil amount when currency pair does not exist" do
    assert_nil @institution.get_amount('USD', 'CLP', 10)
  end

  test "same currency pair for the same institution returns the same amount" do
    @institution.banko.add_rate('USD', 'CAD', 0.9)

    amount_one = @institution.get_amount('USD', 'CAD', 10)
    amount_two = @institution.get_amount('USD', 'CAD', 10)
    assert_equal amount_one, amount_two
  end

  test "same currency pair for the different institution returns the different amount" do
    @institution.banko.add_rate('USD', 'CAD', 0.9)
    first_ins_amount = @institution.get_amount('USD', 'CAD', 10)

    other_institution = Institution.create(name: 'Test Institution', fee: 0)
    other_institution.banko.add_rate('USD', 'CAD', 0.8)
    second_ins_amount = other_institution.get_amount('USD', 'CAD', 10)

    assert_not_equal first_ins_amount, second_ins_amount
  end
end
