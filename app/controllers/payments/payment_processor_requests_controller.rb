module Payments
  class PaymentProcessorRequestsController < ApplicationController
    def result
      Raise "child class must implement result method"
    end

    def confirmation
      Raise "child class must implement confirmation method"
    end
  end
end
