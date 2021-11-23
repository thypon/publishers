# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `rotp` gem.
# Please instead update this file by running `bin/tapioca gem rotp`.

module ROTP; end

class ROTP::Base32
  class << self
    def decode(str); end
    def encode(b); end
    def random(byte_length = T.unsafe(nil)); end
    def random_base32(str_len = T.unsafe(nil)); end

    private

    def decode_quint(q); end
  end
end

class ROTP::Base32::Base32Error < ::RuntimeError; end
ROTP::Base32::CHARS = T.let(T.unsafe(nil), Array)
ROTP::Base32::MASK = T.let(T.unsafe(nil), Integer)
ROTP::Base32::SHIFT = T.let(T.unsafe(nil), Integer)
ROTP::DEFAULT_INTERVAL = T.let(T.unsafe(nil), Integer)

class ROTP::HOTP < ::ROTP::OTP
  def at(count); end
  def provisioning_uri(name, initial_count = T.unsafe(nil)); end
  def verify(otp, counter, retries: T.unsafe(nil)); end
end

class ROTP::OTP
  def initialize(s, options = T.unsafe(nil)); end

  def digest; end
  def digits; end
  def generate_otp(input); end
  def secret; end

  private

  def byte_secret; end
  def int_to_bytestring(int, padding = T.unsafe(nil)); end
  def time_constant_compare(a, b); end
  def verify(input, generated); end
end

ROTP::OTP::DEFAULT_DIGITS = T.let(T.unsafe(nil), Integer)

class ROTP::OTP::URI
  def initialize(otp, account_name:, counter: T.unsafe(nil)); end

  def to_s; end

  private

  def algorithm; end
  def counter; end
  def digits; end
  def issuer; end
  def label; end
  def parameters; end
  def period; end
  def type; end
end

class ROTP::TOTP < ::ROTP::OTP
  def initialize(s, options = T.unsafe(nil)); end

  def at(time); end
  def interval; end
  def issuer; end
  def now; end
  def provisioning_uri(name); end
  def verify(otp, drift_ahead: T.unsafe(nil), drift_behind: T.unsafe(nil), after: T.unsafe(nil), at: T.unsafe(nil)); end

  private

  def get_timecodes(at, drift_behind, drift_ahead); end
  def timecode(time); end
  def timeint(time); end
end
