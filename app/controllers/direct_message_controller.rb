class DirectMessageController < ApplicationController

  before_filter :ensure_twitter_credentials

  def index
    # show list of DM conversations
  end

  def show
    # show a single DM conversation
  end
end
