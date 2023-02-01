# frozen_string_literal: true

class ChargesController < ApplicationController
  def index
    @charges = Charge.all
  end

  def new
    @charge = Charge.new
  end

  def create
    @charge = Charge.new(charge_params)
    if @charge.save
      @signature = signature(@charge)
      render :payu
    else
      render :new
    end
  end

  private

  def charge_params
    params.require(:charge).permit(:amount)
  end

  def signature(charge)
    sng = "#{ENV['PAYU_API_KEY']}~#{ENV['PAYU_MERCHANT_ID']}~#{charge.uid}~#{charge.amount}~#{ENV['PAYU_CURRENCY']}"
    Digest::MD5.hexdigest(sng)
  end
end
