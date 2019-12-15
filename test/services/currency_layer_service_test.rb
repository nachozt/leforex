require 'test_helper'

class CurrencyLayerServiceTest < ActiveSupport::TestCase
  setup do
    @service = CurrencyLayerService.new
    @usd = 'USD'
    @clp = 'CLP'
    @date_sample = '2019-12-13'
    @usd_clp_rate = 764.403912
  end

  #
  # Describe #fx_rate
  #
  test 'it raises error when source and destination are other currency than USD' do
    assert_raises CurrencyLayerService::ArgumentNotSupported do
      @service.fx_rate('CAD', 'CLP', '2019-12-13')
    end
  end

  test 'it requests historical data from CurrencyLayer endpoint' do
    params = cl_query_params(@clp, @date_sample)
    url = base_url.concat(params)
    stub_request(:get, url).to_return(status: 200, body: sample_cl_resp.to_json).times(1)

    @service.fx_rate(@usd, @clp, @date_sample)
  end

  test 'it returns rate for foreign currency' do
    params = cl_query_params(@clp, @date_sample)
    url = base_url.concat(params)
    stub_request(:get, url).to_return(status: 200, body: sample_cl_resp.to_json)

    fx_rate = @service.fx_rate(@usd, @clp, @date_sample)
    assert_equal fx_rate, @usd_clp_rate
  end

  test 'it returns rate for foreign currency when destination is USD' do
    params = cl_query_params(@clp, @date_sample)
    url = base_url.concat(params)
    stub_request(:get, url).to_return(status: 200, body: sample_cl_resp.to_json)

    fx_rate = @service.fx_rate(@clp, @usd, @date_sample)
    assert_equal fx_rate, (1 / @usd_clp_rate)
  end

  test 'it returns 1 when source equals destination (USD)' do
    same_currency = @usd
    params = cl_query_params(same_currency, @date_sample)
    url = base_url.concat(params)
    stub_request(:get, url).to_return(status: 200, body: sample_cl_resp.to_json)

    fx_rate = @service.fx_rate(same_currency, same_currency, @date_sample)
    assert_equal fx_rate, 1
  end

  private

  def base_url
    @service.send(:endpoint_url)
  end

  def cl_query_params(destination, date)
    params = @service.send(:cl_query_params, destination, date)
    params.map{|k,v| "&#{k}=#{v}" }.join('')
  end

  def sample_cl_resp
    { 
      "success":true,
      "terms":"https:\/\/currencylayer.com\/terms",
      "privacy":"https:\/\/currencylayer.com\/privacy",
      "timestamp":1576339746,
      "source":"USD",
      "quotes":{
        "USDUSD":1,
        "USDCAD":1.316625,
        "USDCLP": @usd_clp_rate
      }
    }
  end
end
