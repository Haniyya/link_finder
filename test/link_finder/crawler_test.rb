require_relative '../test_helper'

describe LinkFinder::Crawler do
  before { VCR.insert_cassette 'crawler' }
  after { VCR.eject_cassette }

  let(:keyword) { 'rss' }
  let(:crawler) { LinkFinder::Crawler.new(keyword) }
  let(:url) { 'http://www.kiel.de' }

  it 'returns the correct set of urls' do
    crawler.crawl(url).must_equal ['http://kiel.de/rathaus/_meldungen/rss.php']
  end

  it 'logs the websites it visits' do
    out, _err = capture_subprocess_io do
      crawler.crawl(url)
    end

    out.must_match(/INFO/)
    out.split(/\n/).count.must_equal 39
  end
end
