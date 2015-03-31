require_relative 'spider'

base = "http://library.case.edu/ksl/"
spider = Spider.new(base)
spider.crawl
