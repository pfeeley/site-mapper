require 'net/http'

class Page

  def initialize(url)
    @location = url
    @content = ""
    @links = []

    get_page
    parse_links
  end

  def links
    @links
  end

  def get_page
    url = URI.parse(@location)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
    if res.code == "200"
      @content = res.body
      puts "    Retrieved page #{@location}"
    else
      puts "    Failed with status #{res.code} - #{@location}"
    end
  end

  def parse_links
    puts "      Getting links from #{@location}"
    # TODO: get the links out of the body
  end

end
