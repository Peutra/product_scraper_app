# To do : understand how to secure a GET request... and secure current request
# Maybe http"S" is sufficient ?
# To do : delete unnecessary libs from various tests

class DiffbotQueryService

  require "net/http"
  require "erb"
  require "json"
  require "uri"
  include ERB::Util

  ENDPOINT = "https://api.diffbot.com/v3/product?"
  TOKEN = ENV["DIFFBOT_TOKEN"]

  def get_response(user_url)
    encoded_url = url_encode(user_url)
    uri = URI(ENDPOINT + '&url=' + encoded_url + '&token=' + TOKEN)
    json = JSON.parse(Net::HTTP.get(uri))
    if json.key?('errorCode')
      return false
    else
      format_response(json)
    end
  end

  private

  def format_response(json)
    hash = Hash.new
    json['objects'][0]['title'] ? hash['title'] = json['objects'][0]['title'] : hash['title'] = "NA"
    json['objects'][0]['offerPriceDetails']['amount'] ? hash['price'] = json['objects'][0]['offerPriceDetails']['amount'] : hash['price'] = 0
    json['objects'][0]['offerPriceDetails']['symbol'] ? hash['currency'] = json['objects'][0]['offerPriceDetails']['symbol'] : hash['currency'] = "NA"
    json['objects'][0]['images'][0]['url'] ? hash['image'] = json['objects'][0]['images'][0]['url'] : hash['image'] = "https://placeholdit.imgix.net/~text?txtsize=47&txt=500%C3%97500&w=500&h=500"
    json['objects'][0]['text'] ? hash['description'] = json['objects'][0]['text'] : hash['description'] = "No description"
    json['objects'][0]['pageUrl'] ? hash['url'] = json['objects'][0]['pageUrl'] : hash['url'] = "http://404.com/"
    json['objects'][0]['brand'] ? hash['brand'] = json['objects'][0]['brand'] : hash['brand'] = "Not provided"
    return hash
  end

end
