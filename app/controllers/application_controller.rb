class ApplicationController < ActionController::Base
  protect_from_forgery

  def consumer
    @consumer ||= consumer = OAuth::Consumer.new( ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], {
                  :site => "https://api.twitter.com",
                  :request_token_path => "/oauth/request_token",
                  :access_token_path => "/oauth/access_token",
                  :authorize_path => "/oauth/authorize"
                })
  end

  def ensure_twitter_credentials
    # check that we have twitter credentials - if not, redirect to the root
    return true if session[:access_token]

    redirect_to home_url
    false
  end

end
