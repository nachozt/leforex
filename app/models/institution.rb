class Institution < ApplicationRecord
  attr_accessor :banko

  def banko
    @banko ||= Money::Bank::VariableExchange.new(self)
  end

  def rates
    @rates ||= ExchangeRate.where(institution_id: self.id)
  end

  def set_bank
    Money.default_bank = banko
  end

  def get_amount(from_iso_code, to_iso_code, from_amount)
    set_bank
    Money.from_amount(from_amount, from_iso_code).exchange_to(to_iso_code)
  rescue Money::Bank::UnknownRate => e
    nil
  end

  #
  # get_rate is exposed to be accessible to Money::Bank::VariableExchange
  # it's not supposed to be accessed directly.
  #
  def get_rate(from_iso_code, to_iso_code)
    rate = rates.find_by(from: from_iso_code, to: to_iso_code)
    rate.present? ? rate.rate : nil
  end

  #
  # add_rate is exposed to be accessible to Money::Bank::VariableExchange
  # it's not supposed to be accessed directly.
  #
  def add_rate(from_iso_code, to_iso_code, rate)
    exrate = rates.find_or_initialize_by(from: from_iso_code, to: to_iso_code)
    exrate.rate = rate
    exrate.date = DateTime.now.utc
    exrate.save!
  end
end
