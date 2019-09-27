# Module for encryption and encrypted comaprison
#

require 'bcrypt'

module Authentication
  class Encryptor
    ## Encrypt the string
    def self.digest(string)
      return nil if string.blank?
      ::BCrypt::Password.create(string).to_s
    end

    ## Compare the encrypted hash with the string
    def self.compare(hashed_string, string)
      return false if hashed_string.blank?
      salt = ::BCrypt::Password.new(hashed_string).salt
      digest_string = ::BCrypt::Engine.hash_secret(string, salt)
      Comparator.secure_compare(hashed_string, digest_string)
    end
  end
end
