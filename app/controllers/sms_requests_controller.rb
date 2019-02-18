class SmsRequestsController < ApplicationController
  def create
    msg   = params[:Body].downcase.strip
    from  = params[:From]

    twiml = Twilio::TwiML::MessagingResponse.new do |resp|

      # msg represents a coordinate
      if msg =~ /^[a-z]\d+$/
        pixel = Session.current.add_pixel phone_number: from, coordinate: msg

        if pixel.errors.blank?
          resp.message body: "place your phone in the pocket: #{msg}"
        else
          resp.message body: pixel.errors.values.flatten.join('\n')
        end

      # Reset the session
      elsif msg == ':reset'
        session = Session.create

        if session.errors.blank?
          resp.message body: 'I have reset the session'
        else
          resp.message body: 'something went wrong. I could not reset the session.'
        end

      # msg should be displayed
      elsif msg.length <= 4
        
        Messenger.send_msg(msg)
        resp.message body: "rendering: #{msg}"

      # msg is an unknown command.
      else
        resp.message body: "I don't know what to do with: '#{msg}'"
      end
    end

    render xml: twiml.to_s
  end

  private

  def safe_params
    params.permit(:Body, :From)
  end
end
