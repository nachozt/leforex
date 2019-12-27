class BaseBank
  def initialize
  end

  # TODO: this method should be run by a job once a day
  def update_rates
    Institution.all.each do |institution|
      institution.update_rate("USD", "CLP")
    end
  end
end
