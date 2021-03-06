require_relative 'page'
require_relative 'mapper'

class Spider

  def initialize(base, links_max = 100, map = false)
    @base = base
    @map = map
    @links_new = [base]
    @links_max = links_max
    @links_visited = []
    @pages = []
    @host = URI(base).host
  end

  def crawl
    puts "Crawling URLs from #{@base}"
    while @links_visited.length < @links_max and not @links_new.empty?
      check_link
      puts "      #{@links_new.length} links remaining"
    end
    create_map
  end

  def valid_link(link)
    escaped_link = URI.escape(link.value)
    return false if link.value[0..10] == "javascript:"
    return false if link.value[0..5] == "mailto"
    valid = false
    valid = true if (URI(escaped_link).host == @host and not @links_visited.include?(escaped_link)) or URI(escaped_link).host.nil?
    return valid 
  end

  def check_link
    link = @links_new.first
    puts "  Getting content from #{link}"
    page = Page.new(link)
    @pages << page
    @links_visited << link
    page.links.each do |link|
      if valid_link(link)
        @links_new << 'http://' + @host + URI(URI.escape(link.value)).path.to_s
      end
    end
    @links_new -= [link]
  end

  def create_map
    if @map
      Mapper.new(@pages).map
    end
  end

end
