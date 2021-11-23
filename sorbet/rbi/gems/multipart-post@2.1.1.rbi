# typed: strict

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `multipart-post` gem.
# Please instead update this file by running `bin/tapioca gem multipart-post`.

class CompositeReadIO
  def initialize(*ios); end

  def read(length = T.unsafe(nil), outbuf = T.unsafe(nil)); end
  def rewind; end

  private

  def advance_io; end
  def current_io; end
end

module Parts; end

class Parts::EpiloguePart
  include ::Parts::Part

  def initialize(boundary); end
end

class Parts::FilePart
  include ::Parts::Part

  def initialize(boundary, name, io, headers = T.unsafe(nil)); end

  def build_head(boundary, name, filename, type, content_len, opts = T.unsafe(nil)); end
  def length; end
end

class Parts::ParamPart
  include ::Parts::Part

  def initialize(boundary, name, value, headers = T.unsafe(nil)); end

  def build_part(boundary, name, value, headers = T.unsafe(nil)); end
  def length; end
end

module Parts::Part
  def length; end
  def to_io; end

  class << self
    def file?(value); end
    def new(boundary, name, value, headers = T.unsafe(nil)); end
  end
end

class UploadIO
  def initialize(filename_or_io, content_type, filename = T.unsafe(nil), opts = T.unsafe(nil)); end

  def content_type; end
  def io; end
  def local_path; end
  def method_missing(*args); end
  def opts; end
  def original_filename; end
  def respond_to?(meth, include_all = T.unsafe(nil)); end

  class << self
    def convert!(io, content_type, original_filename, local_path); end
  end
end
