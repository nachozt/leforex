class InstitutionRates
  attr_accessor :institution_id

  def initialize(institution_id)
    @institution_id = self.institution_id
    @rates = ExchangeRate.where(institution_id: institution_id)
  end

  def get_rate(from_iso_code, to_iso_code)
    rate = @rates.find_by(from: from_iso_code, to: to_iso_code)
    rate.present? ? rate.rate : nil
  end

  def add_rate(from_iso_code, to_iso_code, rate)
    exrate = @rates.find_or_initialize_by(from: from_iso_code, to: to_iso_code)
    exrate.rate = rate
    exrate.date = DateTime.now.utc
    exrate.save!
  end
end
