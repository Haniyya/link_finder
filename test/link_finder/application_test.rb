require_relative '../test_helper'

describe LinkFinder::Application do
  before do
    VCR.insert_cassette 'crawler'
    def application.continue?
      false
    end
  end
  after { VCR.eject_cassette }

  let(:keyword) { 'rss' }
  let(:application) { LinkFinder::Application.new(keyword) }
  let(:url) { 'http://www.kiel.de' }

  it 'prints the correct url last' do
    out, _err = capture_subprocess_io do
      application.scan(url)
    end

    out.split(/\n/).last.must_equal('http://kiel.de/rathaus/_meldungen/rss.php'.green)
  end
end
