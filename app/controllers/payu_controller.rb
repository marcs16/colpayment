# frozen_string_literal: true

class PayuController < Payments::PaymentProcessorRequestsController
  skip_before_action :verify_authenticity_token, only: [:confirmation]
  def result
    @charge = Charge.find_by(uid: params[:referenceCode])

    if @charge.nil?
      @error = 'Charge not found'

    elsif params[:signature] != signature(@charge, params[:transactionState])
      @error = 'Invalid signature'
    end
    return unless @error.nil?

    update_status(@charge, params[:transactionState])
    update_payment_method(@charge, params[:polPaymentMethodType])
  end

  def confirmation
    @charge = Charge.find_by(uid: params[:reference_sale])

    if @charge.nil?
      head :unprocessible_entity
      return
    end

    @charge.update!(response_data: params.as_json)

    if params[:sign] == signature(@charge, params[:state_pol])
      update_status(@charge, params[:state_pol])
      update_payment_method(@charge, params[:polPaymentMethodType])
      head :ok
    else
      head :unprocessible_entity
    end
  end

  private

  def signature(charge, state)
    sng = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~#{charge.amount}~#{ENV['PAYU_CURRENCY']}~#{state}"
    Digest::MD5.hexdigest(sng)
  end

  def update_status(charge, status)
    case status
    when '4'
      charge.paid!
    when '7'
      charge.pending!
    when '6'
      charge.rejected!
      charge.update!(error_messages: params[:response_message_pol])
    end
  end

  def update_payment_method(charge, payment_method)
    case payment_method
    when '1'
      charge.debit_card!
    when '2'
      charge.credit_card!
    when '3'
      charge.pse!
    when '4'
      charge.cash!
    when '5'
      charge.referenced!
    end
  end
end
