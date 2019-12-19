# require 'open-uri'
# require 'nokogiri'
require 'money'
# require 'money/rates_store/store_with_historical_data_support'

class CurrencyLayerBank < Money::Bank::VariableExchange
  def initialize() # TODO: pass InstitutionRates instance
    super
  end
end
