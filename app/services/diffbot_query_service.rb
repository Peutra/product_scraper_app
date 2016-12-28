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

  # To do : dryify
  def format_response(json)
    hash = Hash.new
    title = json['objects'][0]['title'].nil? rescue true
    amount = json['objects'][0]['offerPriceDetails']['amount'].nil? rescue true
    currency = json['objects'][0]['offerPriceDetails']['symbol'].nil? rescue true
    image = json['objects'][0]['images'][0]['url'].nil? rescue true
    text = json['objects'][0]['text'].nil? rescue true
    url = json['objects'][0]['pageUrl'].nil? rescue true
    brand = json['objects'][0]['brand'].nil? rescue true
    !title ? hash['title'] = json['objects'][0]['title'] : hash['title'] = "NA"
    !amount ? hash['price'] = json['objects'][0]['offerPriceDetails']['amount'] : hash['price'] = 0
    !currency ? hash['currency'] = json['objects'][0]['offerPriceDetails']['symbol'] : hash['currency'] = "NA"
    !image ? hash['image'] = json['objects'][0]['images'][0]['url'] : hash['image'] = "https://placeholdit.imgix.net/~text?txtsize=47&txt=500%C3%97500&w=500&h=500"
    !text ? hash['description'] = json['objects'][0]['text'] : hash['description'] = "No description"
    !url ? hash['url'] = json['objects'][0]['pageUrl'] : hash['url'] = "http://404.com/"
    !brand ? hash['brand'] = json['objects'][0]['brand'] : hash['brand'] = "Not provided"
    return hash
  end

end
