# frozen_string_literal: true

require "twitter"

module TaskReporter
  # Twitter interface voor TaskReporter
  class Twitter
    # Configureren van de twitter client
    #
    # client = TaskReporter::Twitter.configure do |config|
    #   config.consumer_key        = "YOUR_CONSUMER_KEY"
    #   config.consumer_secret     = "YOUR_CONSUMER_SECRET"
    #   config.access_token        = "YOUR_ACCESS_TOKEN"
    #   config.access_token_secret = "YOUR_ACCESS_SECRET"
    # end
    def self.configure
      @client = Twitter::REST::Client.new do |config|
        yield config
      end
    end

    def self.update(msg)
      @client.update msg
    end
  end
end
