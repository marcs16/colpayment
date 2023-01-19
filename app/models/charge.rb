# == Schema Information
#
# Table name: charges
#
#  id             :bigint           not null, primary key
#  amount         :decimal(, )      default(0.0)
#  error_messages :text
#  payment_method :integer          default(0)
#  response_data  :jsonb
#  status         :integer          default(0)
#  uid            :string(50)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Charge < ApplicationRecord
  # create the class status and set the enum values, the class status will be in
  # the directory
  enum status: Statuses.new.statuses
  enum payment_method: Statuses.new.payment_methods

  before_create :generate_uid


  private 

  def generate_uid
    # generate a random string with 6 characters and validate that the uid doesn't exist in the database
    # if the uid exists, generate a new one
    begin
      self.uid = SecureRandom.hex(6)
    end while self.class.exists?(uid: uid)
  end
end
