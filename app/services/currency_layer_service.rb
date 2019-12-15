require 'rest-client'

class CurrencyLayerService
  class ArgumentNotSupported < StandardError; end

  def initialize; end

  def fx_rate(source, destination, date)
    raise ArgumentNotSupported unless source == 'USD' || destination == 'USD'

    if destination == 'USD'
      ex_rate = get_fx_rate_from_3rd_party(source, date)
      return (1 / ex_rate)
    end

    ex_rate = get_fx_rate_from_3rd_party(destination, date)
    # ex_rate = 764.403912 #--- This is for testing only ---#
    return ex_rate
  end

  private

  # CurrencyLayer free version only allows source = USD by default
  def get_fx_rate_from_3rd_party(destination, date)
    resp = RestClient.get(endpoint_url, params: cl_query_params(destination, date))

    # TODO: handle error responses
    parsed_resp = JSON.parse(resp.body)
    currency_pair = "USD".concat(destination)

    parsed_resp["quotes"][currency_pair]
  end

  def endpoint_url
    # "http://www.apilayer.net/api/live?access_key=#{Rails.application.credentials[:currency_layer_api]}"
    "http://www.apilayer.net/api/live?access_key=ssersd0f644f" #--- This is for testing only ---#
  end

  def cl_query_params(destination, date)
    {
      currencies: destination,
      date: date
    }
  end
end
