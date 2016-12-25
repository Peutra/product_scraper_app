require 'net/http'
require "erb"
require 'json'
include ERB::Util

class DiffbotQueryService

  ENDPOINT = URI("https://api.diffbot.com/v3/product")
  TOKEN = ENV["DIFFBOT_TOKEN"]

  def get_response(url)
    request = Net::HTTP::Get.new(ENDPOINT.request_uri)
    request.add_field("url", url)
    request.add_field("token", TOKEN)
    response = http.request(request)
    result = JSON.parse(response)
    binding pry
  end

  def format_response(content)

  end

end
