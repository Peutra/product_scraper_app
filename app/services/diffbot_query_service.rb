# TO DO understand how to secure a GET request... and secure current request
# Maybe https is sufficient ?

class DiffbotQueryService

  require "net/http"
  require "erb"
  require "json"
  require "uri"
  include ERB::Util

  ENDPOINT = "https://api.diffbot.com/v3/product?"
  TOKEN = ENV["DIFFBOT_TOKEN"]

  def get_response(user_url)
    uri = URI(ENDPOINT + '&url=' + user_url + '&token=' + TOKEN)
    format_response(JSON.parse(Net::HTTP.get(uri)))
  end

  private

  def format_response(json)        
    hash = Hash.new
    hash['title'] = json['objects'][0]['title']
    hash['price'] = json['objects'][0]['offerPriceDetails']['amount']
    hash['currency'] = json['objects'][0]['offerPriceDetails']['symbol']
    hash['image'] = json['objects'][0]['images'][0]['url']
    hash['description'] = json['objects'][0]['text']
    hash['url'] = json['objects'][0]['pageUrl']
    hash['brand'] = json['objects'][0]['brand']
    return hash
  end

end
