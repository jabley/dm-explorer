class SessionController < ApplicationController
  def new
    request_token = consumer.get_request_token(:oauth_callback => "http://127.0.0.1:3000/oauth/callback")

    session[:request_token] = request_token
    redirect_to request_token.authorize_url
  end

  def create
    # Get the twitter access token from the request and redirect to /direct_messages
    access_token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:access_token] = access_token.token
    session[:access_token_secret] = access_token.secret
    
    redirect_to "/direct-messages"
  end
end
