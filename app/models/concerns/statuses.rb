class Statuses

  STATUSES = statuses
  PAYMENT_METHODS = payment_methods
  def statuses
    {
      created: 0,
      pending: 1,
      paid: 2,
      rejected: 3,
      error: 4
    }
  end

  def payment_methods
    {
      unknown: 0,
      credit_card: 1,
      debit_card: 2,
      pse: 3,
      cash: 4,
      referenced: 5
    }
  end

end