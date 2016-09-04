class CommonFunctions
  def calculate_average(amount)
    transaction_amount = amount.to_i
    if (transaction_amount)>=0
      credits = credits + transaction_amount
    elsif (transaction_amount)<0
      debits = debits + transaction_amount.abs
    else
      raise "Unknown amount"
    end
    aggregate_amount = credits+debits
  end
end