module Bitstamp
  module Net
    def self.to_uri(path)
      return "https://www.bitstamp.net/api#{path}/"
    end

    def self.get(path, options={})
      RestClient.get(self.to_uri(path))
    end

    def self.post(path, options={})
      RestClient.post(self.to_uri(path), self.bitstamp_options(options))
    end

    def self.patch(path, options={})
      RestClient.put(self.to_uri(path), self.bitstamp_options(options))
    end

    def self.delete(path, options={})
      RestClient.delete(self.to_uri(path), self.bitstamp_options(options))
    end

    def self.bitstamp_options(options={})
      if Bitstamp.configured?
        options[:key] = Bitstamp.key
        options[:nonce] = utc_microseconds.to_s
        options[:signature] = HMAC::SHA256.hexdigest(Bitstamp.secret, options[:nonce]+Bitstamp.client_id.to_s+options[:key]).upcase
      end

      options
    end

    #
    # The current time in microseconds from the UNIX Epoch in the UTC
    #
    def self.utc_microseconds
      (Time.now.gmtime.to_f * 1_000_000).to_i
    end
    private_class_method :utc_microseconds

  end
end
