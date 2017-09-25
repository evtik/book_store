class CreditCardDecorator < Draper::Decorator
  delegate_all

  def starred_number
    "** ** ** #{model.number[-4..-1]}"
  end

  def month_full_year
    ('' << model.month_year).insert(3, '20')
  end
end
