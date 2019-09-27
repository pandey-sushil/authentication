# Custome comparison method to compare passwords hash safely
#

module Authentication
  class Comparator
    ## Compare each byte to avoide timing attacks
    # https://codahale.com/a-lesson-in-timing-attacks/
    def self.secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end
  end
end
