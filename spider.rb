require_relative 'page'

class Spider

  def initialize(base, links_max = 100)
    @base = base
    @links_new = [base]
    @links_max = links_max
    @links_visited = []
  end

  def crawl
    puts "Crawling URLs from #{@base}"
    while @links_visited.length < @links_max and not @links_new.empty?
      check_link
    end
  end

  def check_link
    link = @links_new.first
    puts "  Getting content from #{link}"
    page = Page.new(link)
    @links_visited << link
    page.links.each { |link| @links_new << link unless @links_visited.contains?(link) }
    @links_new -= [link]
  end

end
