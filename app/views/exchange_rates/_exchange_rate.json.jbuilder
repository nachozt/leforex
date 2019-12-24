json.extract! exchange_rate, :id, :from, :to, :rate, :date, :institution_id, :created_at, :updated_at
json.url exchange_rate_url(exchange_rate, format: :json)
