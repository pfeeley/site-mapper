class Mapper

  def initialize(pages)
    @pages = pages
  end

  def map
    @pages.each do |page|
      puts page.links
    end
  end

end
