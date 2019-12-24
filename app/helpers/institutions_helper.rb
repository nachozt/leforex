module InstitutionsHelper
  def dynamic_amount(institution, conversion_input)
    from_iso_code = conversion_input[:form]
    to_iso_code = conversion_input[:to]
    from_amount = conversion_input[:quantity].to_i
    
    dyn_amnt = institution.get_amount(from_iso_code, to_iso_code, from_amount)
    dyn_amnt.present? ? number_to_currency(dyn_amnt) : "?"
  end
end
