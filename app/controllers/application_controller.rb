class ApplicationController < ActionController::Base
  protect_from_forgery

  def ensure_twitter_credentials
    # TODO: check that we have twitter credentials - if not, redirect to the root
    true
  end

end
