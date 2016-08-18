module LinkFinder
  #
  # A Crawler looking for links. Needs a Keyword for initialization
  #
  class Crawler
    include Logging

    attr_accessor :keyword, :depth_limit, :max_depth_limit
    attr_writer :findings
    FORBIDDEN = %w(.jpg .mov .pdf .JPG).freeze
    DEFAULT_MAX_DEPTH = 3

    def initialize(keyword)
      @keyword         = keyword.downcase
      @depth_limit     = 1
      @max_depth_limit = DEFAULT_MAX_DEPTH
    end

    def findings
      @findings ||= []
    end

    def crawl(uri)
      Anemone.crawl(uri, depth_limit: depth_limit) do |anemone|
        page_focus(anemone)

        anemone.on_every_page do |page|
          logger.info "Crawling #{page.url}"
          links(page.body.to_s).each { |l| scan(l) }
        end
      end

      results
    end

    def go_deeper(uri)
      self.depth_limit += 1
      logger.warn "Going deeper to level #{depth_limit}.".red
      crawl(uri)
    end

    private

    def page_focus(anemone)
      anemone.instance_eval do
        anemone.focus_crawl do |page|
          page.links.select do |link|
            !FORBIDDEN.include?(File.extname(link.to_s))
          end
        end
      end
    end

    def results
      findings.flatten.uniq
    end

    def links(html)
      URI.extract(html, %w(http https))
    end

    def scan(link)
      link.to_s.split(/\W/).each do |word|
        next unless word.downcase.eql? keyword
        findings << link.to_s
        logger.info "Found: #{link}".green
        return true
      end
      false
    end
  end
end
