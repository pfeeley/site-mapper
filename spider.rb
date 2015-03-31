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
    end
    create_map
  end

  def check_link
    link = @links_new.first
    puts "  Getting content from #{link}"
    page = Page.new(link)
    @pages << page
    @links_visited << link
    page.links.each do |link|
      if URI(link).host == @host and not @links_visited.include?(link)
        puts link
        if link.include? @host
          @links_new << link
        else
          @links_new << @host + link
        end
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
