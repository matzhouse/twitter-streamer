require 'rubygems'
require 'tweetstream'
require 'riak'
require 'growl'

TweetStream.configure do |config|
  config.consumer_key = 'xxxx'
  config.consumer_secret = 'xxxx'
  config.oauth_token = 'xxxx'
  config.oauth_token_secret = 'xxxx'
  config.auth_method = :oauth
  config.parser   = :yajl
end

#Growl.notify "starting to follow twitter stream!", :title => "Streamr!"

client = Riak::Client.new
bucket = client.bucket("tweets")
# This will pull a sample of all tweets based on
# your Twitter account's Streaming API role.
TweetStream::Client.new.track('bieber') do |status|
  # The status object is a special Hash with
  # method access to its keys.
  
  object = bucket.new(status.id_str)
  object.data = status.text
  object.content_type = "text/plain"
  object.store
  puts status.id_str

end