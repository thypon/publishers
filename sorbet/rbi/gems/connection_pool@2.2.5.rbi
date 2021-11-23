# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `connection_pool` gem.
# Please instead update this file by running `bin/tapioca gem connection_pool`.

class ConnectionPool
  def initialize(options = T.unsafe(nil), &block); end

  def available; end
  def checkin; end
  def checkout(options = T.unsafe(nil)); end
  def reload(&block); end
  def shutdown(&block); end
  def size; end
  def then(options = T.unsafe(nil)); end
  def with(options = T.unsafe(nil)); end

  class << self
    def wrap(options, &block); end
  end
end

ConnectionPool::DEFAULTS = T.let(T.unsafe(nil), Hash)
class ConnectionPool::Error < ::RuntimeError; end
class ConnectionPool::PoolShuttingDownError < ::ConnectionPool::Error; end

class ConnectionPool::TimedStack
  def initialize(size = T.unsafe(nil), &block); end

  def <<(obj, options = T.unsafe(nil)); end
  def empty?; end
  def length; end
  def max; end
  def pop(timeout = T.unsafe(nil), options = T.unsafe(nil)); end
  def push(obj, options = T.unsafe(nil)); end
  def shutdown(reload: T.unsafe(nil), &block); end

  private

  def connection_stored?(options = T.unsafe(nil)); end
  def current_time; end
  def fetch_connection(options = T.unsafe(nil)); end
  def shutdown_connections(options = T.unsafe(nil)); end
  def store_connection(obj, options = T.unsafe(nil)); end
  def try_create(options = T.unsafe(nil)); end
end

class ConnectionPool::TimeoutError < ::Timeout::Error; end
ConnectionPool::VERSION = T.let(T.unsafe(nil), String)

class ConnectionPool::Wrapper < ::BasicObject
  def initialize(options = T.unsafe(nil), &block); end

  def method_missing(name, *args, **kwargs, &block); end
  def pool_available; end
  def pool_shutdown(&block); end
  def pool_size; end
  def respond_to?(id, *args); end
  def with(&block); end
  def wrapped_pool; end
end

ConnectionPool::Wrapper::METHODS = T.let(T.unsafe(nil), Array)
