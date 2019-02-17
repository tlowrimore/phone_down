class Pixel < ApplicationRecord
  belongs_to :session

  validates :phone_number,
            presence: true,
            uniqueness: {
              scope: :session_id,
              message: 'This phone number is already in use. Try another.'
            }
  validates :coordinate,
            presence: true,
            uniqueness: {
              scope: :session_id,
              message: 'This coordinate is already in use. Try another.'
            }

end
