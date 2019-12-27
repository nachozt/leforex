class Institution < ApplicationRecord
  attr_accessor :banko
  validates :bank, presence: true
  validate :valid_bank?

  BANK_LIST = [
    { name: "Manual", type: "manual" },
    { name: "CurrencyLayerBank", type: "auto" },
    { name: "TransferWise", type: "auto" },
    { name: "BancoDeChile", type: "auto" }
  ]

  def banko
    @banko ||= Money::Bank::VariableExchange.new(self)
  end

  def rates
    @rates ||= ExchangeRate.where(institution_id: self.id)
  end

  def valid_bank?
    return if bank.blank? # error handled by presence validation

    bnk = BANK_LIST.find{|k,v| k[:name] == bank }
    errors.add(:bank, "Bank name not found") unless bnk.present?
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

  # TODO: this method should be run by a job once a day
  def update_rates
    # @bank_service.update_rates
  end

  def bank_service
    @bank_service ||= Object.const_get(self.bank).new
  end
end
