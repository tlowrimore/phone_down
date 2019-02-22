class SmsRequestsController < ApplicationController
  def create
    msg   = params[:Body].downcase.strip
    from  = params[:From]

    twiml = Twilio::TwiML::MessagingResponse.new do |resp|

      # msg represents a coordinate
      if msg =~ /^[a-z]\d+$/
        if Session.current.pixel_exists?(coordinate: msg)
          status "Pixel collision.  Doing nothing."

          resp.message body: "a phone is already in the pocket: #{msg}.  Talk to Ondine."
        else
          status "Adding pixel at: #{msg}"

          pixel = Session.current.add_pixel phone_number: from, coordinate: msg

          if pixel.errors.blank?
            resp.message body: "place your phone in the pocket: #{msg}"
          else
            resp.message body: pixel.errors.values.flatten.join('\n')
          end
        end

      elsif msg =~ /^\:remove\s*([a-z]\d)+$/
        status "Removing pixel at: #{$1}"

        Session.current.remove_pixel(coordinate: $1)
        resp.message body: "The phone at #{$1} has been removed."

      # Reset the session
      elsif msg == ':reset'
        status "Resetting session"
        session = Session.create

        if session.errors.blank?
          resp.message body: 'I have reset the session'
        else
          resp.message body: 'something went wrong. I could not reset the session.'
        end

      # msg should be displayed
      elsif msg.length <= 4
        status "Rendering message: #{msg}"

        Messenger.send_msg(msg)
        resp.message body: "rendering: #{msg}"

      # msg is an unknown command.
      else
        status "Unknown command received: #{msg}"
        resp.message body: "I don't know what to do with: '#{msg}'"
      end
    end

    render xml: twiml.to_s
  end

  private

  def status(msg)
    puts '~' * 40
    puts msg
    puts '~' * 40
  end

  def safe_params
    params.permit(:Body, :From)
  end
end
