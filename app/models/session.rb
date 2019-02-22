class Session < ApplicationRecord
  has_many :pixels, dependent: :destroy

  default_scope -> { order(created_at: :asc) }

  # Returns the current session
  def self.current
    last || create
  end

  def pixel_exists?(coordinate:)
    pixels.exists?(coordinate: coordinate)
  end

  # Registers a new pixel in the session.  If the number already exists for this
  # session, the call is a no-op.
  def add_pixel(phone_number:, coordinate:)
    pixels
    .create_with(coordinate: coordinate)
    .find_or_create_by phone_number: phone_number
  end

  def remove_pixel(coordinate:)
    pixel = pixels.find_by(coordinate: coordinate)
    pixel && pixel.destroy
  end
end
