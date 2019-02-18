# Phone Down

## Up and Running

1. enter `rails s -p3214` in a new terminal window
2. enter `ngrok http 3214` in a different terminal window
3. copy the _https Forwarding_ address from the ngrok output
4. in a browser, go to: https://www.twilio.com/console/phone-numbers/incoming
5. select the phone number associated with this project
6. in the _Configure > Messaging_ section, set the field labeled: _A MESSAGE COMES IN_ to the value copied in **step 3**, with the path `/sms_requests` appended to the end.  E.g. `https://05bee6cb.ngrok.io/sms_requests`

## Commands

The following is a list of availble SMS commands.

- `:reset`: resets the session, removing all previously registered phone numbers.
- `<coordinate>`: registers the phone from which the coordinate was sent, with the current session.  A `<coordinate>` is a letter, a-z followed by a number.  E.g. `a4`,
- `<word>`: a word containing 4 or less characters, to be rendered on the _screen_ of phones.  E.g. `love`.
