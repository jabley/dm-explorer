class DirectMessageController < ApplicationController

  before_filter :ensure_twitter_credentials

  def index
    # show list of DM conversations
    @received_direct_messages = slurp_messages
    @senders = @received_direct_messages.inject({}) do |acc, message|
      acc[message["sender"]["name"]] = message["sender_id"]
      acc
    end
  end

  def show
    # show a single DM conversation
    received_direct_messages = slurp_messages
    messages_from = received_direct_messages.find_all{ |m| m["sender_id"] == params[:id].to_i }

    sent_direct_messages = slurp_messages("/1.1/direct_messages/sent.json?count=200&skip_status=1")
    messages_to = sent_direct_messages.find_all{ |m| m["recipient_id"] == params[:id].to_i }

    @direct_messages = merge_thread(messages_from, messages_to)
  end

  private
  # Returns an OAuth::AccessToken suitable for retrieving content from the API
  def access_token
    @access_token ||= OAuth::AccessToken.from_hash(consumer,
      :oauth_token => session[:access_token],
      :oauth_token_secret => session[:access_token_secret])
  end

  # Given an array of JSON messages, extracts the earliest ID or nil if there isn't one
  def earliest_id(messages)
    # TODO: This assumes that messages are sorted already. Is that documented, or
    # should we explicitly sort.
    result = if messages.last
      messages.last["id"]
    else
      nil
    end

    result
  end

  # Merges two array of JSON DM objects, returning a sorted array
  def merge_thread(first, second)
    result = []
    result.push(*first)
    result.push(*second)
    # FIXME: Minor meh - sorting by id rather than a date?
    result.sort {|a, b| a["id"] <=> b["id"] }
  end

  # Parses a Net::HTTP response, returning a non-nil array of JSON objects
  def parse_response(response)
    case response.code.to_i
    when 200
      JSON.parse(response.body)
    when 429
      puts "Rate limited for another #{response["X-Rate-Limit-Reset"].to_i - Time.now.to_i} seconds"
      []
    end
  end

  # Consumes all of the messages available by the API (currently limited to 800?)
  # Returns a non-nill array of JSON objects representing DMs
  def slurp_messages(base_path = "/1.1/direct_messages.json?count=200&skip_status=1")
    messages = parse_response(access_token.get(base_path))
    
    earlier_messages = messages
    earliest_id_seen = earliest_id(earlier_messages)

    while earliest_id_seen
      earlier_messages = parse_response(access_token.get("#{base_path}&max_id=#{earliest_id_seen - 1}"))
      messages.push(*earlier_messages)
      earliest_id_seen = earliest_id(earlier_messages)
    end

    messages
  end

end
