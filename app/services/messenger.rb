module Messenger

  # number of horizontal pixels required to render a character
  CHAR_WIDTH  = 3
  ROWS        = %w(a b c d e)
  ON          = 1

  class << self

    # Maps the characters of the message to 'pixels', maps the pixels to
    # a set of phone numbers--where each phone number is a pixel to light--and
    # dispatches the message to each phone number.
    def send_msg(msg)
      coords = msg.to_s.chars.flat_map.with_index do |char, index|
        pixels = CharacterMap[char]
        coordinates(pixels, index)
      end

      phone_numbers(coords).each do |phone_number|
        client.api.account.messages.create(
          from: from_number,
          to:   phone_number,
          body: msg
        )
      end
    end

    # -----------------------------------------------------
    # Private Methods
    # -----------------------------------------------------

    private

    def phone_numbers(coordinates)
      Session
      .current
      .pixels
      .where(coordinate: coordinates)
      .pluck(:phone_number)
    end

    def coordinates(pixels, index)
      coords = pixels.map.with_index do |row, row_coord|
        row.map.with_index do |pixel, col_coord|
          if pixel == ON
            a = ROWS[row_coord]
            b = col_coord + 1 + (index * CHAR_WIDTH)

            "#{a}#{b}"
          end
        end
      end

      coords.flatten.compact
    end

    def client
      @client ||= begin
        sid, auth_token =
          Rails.application.credentials.twilio.values_at(:sid, :auth_token)

        Twilio::REST::Client.new sid, auth_token
      end
    end

    def from_number
      @from_number ||= Rails.application.credentials.twilio[:active_number]
    end
  end
end
