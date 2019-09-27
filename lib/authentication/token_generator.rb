# Module for generating safe tokens
#

require 'openssl'

module Authentication
  class TokenGenerator

    # generates base64 token
    def self.friendly_token(length = 20)
      rlength = (length * 3) / 4
      SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
    end

    ## generates uniq base64 & hex token
    def self.generate(klass, column, digest = 'SHA256')
      loop do
        raw = friendly_token
        enc = OpenSSL::HMAC.hexdigest(digest, column, raw)
        break [raw, enc] unless klass.find_by({ column => enc })
      end
    end

    ## return the hex value of value
    def self.digest(column, value, digest='SHA256')
      value.present? && OpenSSL::HMAC.hexdigest(digest, column, value.to_s)
    end
  end
end
