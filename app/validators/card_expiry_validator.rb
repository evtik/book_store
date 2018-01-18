class CardExpiryValidator < ActiveModel::Validator
  def validate(record)
    month, year = record.month_year.split('/')
    expiry = DateTime.new(('20' << year).to_i, month.to_i)
    return if expiry >= DateTime.now.beginning_of_month
    record.errors[:month_year] << I18n.t(
      'errors.attributes.month_year.past_date'
    )
  rescue
    record.errors[:month_year] << I18n.t('errors.attributes.month_year.invalid')
  end
end
