require "twiliolib.rb"
# your Twilio authentication credentials
ACCOUNT_SID = 'AC0e331b7fa11f13be73a32e5311a74969'
ACCOUNT_TOKEN = 'e948aaf8caad373ae54918c175fd8786'
# version of the Twilio REST API to use
API_VERSION = '2008-08-01'
# base URL of this application
BASE_URL = "http://morning-rain-78.heroku.com/appointmentreminder/"
# Outgoing Caller ID you have previously validated with Twilio
CALLER_ID = 'NNNNNNNNNN'


class AppointmentreminderController < ApplicationController
  # Use the Twilio REST API to initiate an outgoing call
  def makecall
  if !params['number']
  redirect_to({ :action => '.', 'msg' => 'Invalid phone number' })
  return
  end

  # parameters sent to Twilio REST API
  d = {
  'Caller' => CALLER_ID,
  'Called' => params['number'],
  'Url' => BASE_URL + '/reminder',
  }
  begin
  account = Twilio::RestAccount.new(ACCOUNT_SID, ACCOUNT_TOKEN)
  resp = account.request(
  "/#{API_VERSION}/Accounts/#{ACCOUNT_SID}/Calls",
  'POST', d)
  resp.error! unless resp.kind_of? Net::HTTPSuccess
  rescue StandardError => bang
  redirect_to({ :action => '.', 'msg' => "Error #{ bang }" })
  return
  end

  redirect_to({ :action => '',
  'msg' => "Calling #{ params['number'] }..." })
  end
  
  # TwiML response that says the reminder to the caller and presents a
  # short menu: 1. repeat the msg, 2. directions, 3. good bye
  def reminder
  @postto = BASE_URL + '/directions'
  respond_to do |format|
  format.xml { @postto }
    end
  end
  # TwiML response that inspects the caller's menu choice:
  # - says good bye and hangs up if the caller pressed 3
  # - repeats the menu if caller pressed any other digit besides 2 or 3
  # - says the directions if they pressed 2 and redirect back to menu
  def directions
      if params['Digits'] == '3'
          redirect_to :action => 'goodbye'
          return
      end

      if !params['Digits'] or params['Digits'] != '2'
          redirect_to :action => 'reminder'
          return
      end

      @redirectto = BASE_URL + '/reminder',
      respond_to do |format|
          format.xml { @redirectto }
      end
  end
end
