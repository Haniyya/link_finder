module LinkFinder
  module Logging
    def logger
      Logging.logger
    end

    def self.logger(destination = nil)
      @logger ||= Logger.new(STDOUT)
    end
  end
end
