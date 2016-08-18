module LinkFinder
  #
  # The CLI to the Crawler.
  #
  class Application
    include Logging

    attr_accessor :crawler, :prompt

    def initialize(keyword, _options = {})
      @crawler = Crawler.new(keyword)
      @prompt  = TTY::Prompt.new
    end

    def scan(uri)
      logger.info "Crawling #{uri}".yellow
      urls = crawler.crawl(uri)
      urls.each { |f| puts(f.green) }
      while continue?
        urls = crawler.go_deeper(uri)
        urls.each { |f| puts(f.green) }
      end
    end

    def continue?
      prompt.yes?('Do you want to go one level deeper?')
    end
  end
end
