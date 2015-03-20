require 'net/http'
require 'nokogiri'

class Page

  def initialize(url)
    @location = url
    @content = ""
    @links = []
    @depth = 0

    get_page
    parse_links
    get_depth
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
      @location = res.to_hash["content-location"].first
      puts "    Retrieved page #{@location}"
    else
      puts "    Failed with status #{res.code} - #{@location}"
    end
  end

  def parse_links
    puts "      Getting links from #{@location}"
    page_content = Nokogiri::HTML(@content)
    @links = page_content.xpath("//a/@href")
    puts "      Found #{@links.length} unique links"
    # TODO: parse the code for meta redirects to get redirect links
  end

  def get_depth
    path = URI.parse(@location).path
    @depth = path.split("/").length
  end

end
