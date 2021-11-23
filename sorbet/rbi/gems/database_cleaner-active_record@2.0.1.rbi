# typed: strict

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `database_cleaner-active_record` gem.
# Please instead update this file by running `bin/tapioca gem database_cleaner-active_record`.

module DatabaseCleaner
  class << self
    def [](*args, &block); end
    def allow_production; end
    def allow_production=(_arg0); end
    def allow_remote_database_url; end
    def allow_remote_database_url=(_arg0); end
    def clean(*args, &block); end
    def clean_with(*args, &block); end
    def cleaners; end
    def cleaners=(_arg0); end
    def cleaning(*args, &block); end
    def start(*args, &block); end
    def strategy=(*args, &block); end
    def url_allowlist; end
    def url_allowlist=(_arg0); end
    def url_whitelist; end
    def url_whitelist=(_arg0); end
  end
end

module DatabaseCleaner::ActiveRecord
  class << self
    def config_file_location; end
    def config_file_location=(path); end
  end
end

class DatabaseCleaner::ActiveRecord::Base < ::DatabaseCleaner::Strategy
  def connection_class; end
  def connection_hash; end
  def connection_hash=(_arg0); end
  def db=(*_arg0); end

  private

  def active_record_config_hash_for(db); end
  def database_for(model); end
  def establish_connection; end
  def load_config; end
  def lookup_from_connection_pool; end
  def valid_config(connection_file, db); end

  class << self
    def exclusion_condition(column_name); end
    def migration_table_name; end
  end
end

class DatabaseCleaner::ActiveRecord::ConnectionWrapper < ::SimpleDelegator
  def initialize(connection); end
end

module DatabaseCleaner::ActiveRecord::ConnectionWrapper::AbstractAdapter
  def database_cleaner_table_cache; end
  def database_cleaner_view_cache; end
  def database_tables; end
  def truncate_table(table_name); end
  def truncate_tables(tables); end
end

module DatabaseCleaner::ActiveRecord::ConnectionWrapper::AbstractMysqlAdapter
  def pre_count_tables(tables); end
  def pre_count_truncate_tables(tables); end

  private

  def auto_increment_value(table); end
  def has_been_used?(table); end
  def has_rows?(table); end
  def row_count(table); end
end

module DatabaseCleaner::ActiveRecord::ConnectionWrapper::PostgreSQLAdapter
  def database_cleaner_table_cache; end
  def database_tables; end
  def pre_count_tables(tables); end
  def pre_count_truncate_tables(tables); end
  def truncate_tables(table_names); end

  private

  def has_been_used?(table); end
  def has_rows?(table); end
  def has_sequence?(table); end
  def tables_with_schema; end
end

module DatabaseCleaner::ActiveRecord::ConnectionWrapper::SQLiteAdapter
  def pre_count_tables(tables); end
  def pre_count_truncate_tables(tables); end
  def truncate_table(table_name); end
  def truncate_tables(tables); end

  private

  def fetch_sequences; end
  def has_been_used?(table, sequences); end
  def row_count(table); end
  def uses_sequence?; end
end

class DatabaseCleaner::ActiveRecord::Deletion < ::DatabaseCleaner::ActiveRecord::Truncation
  def clean; end

  private

  def build_table_stats_query(connection); end
  def delete_table(connection, table_name); end
  def delete_tables(connection, table_names); end
  def information_schema_exists?(connection); end
  def table_stats_query(connection); end
  def tables_to_truncate(connection); end
  def tables_with_new_rows(connection); end
end

class DatabaseCleaner::ActiveRecord::Transaction < ::DatabaseCleaner::ActiveRecord::Base
  def clean; end
  def start; end
end

class DatabaseCleaner::ActiveRecord::Truncation < ::DatabaseCleaner::ActiveRecord::Base
  def initialize(opts = T.unsafe(nil)); end

  def clean; end

  private

  def cache_tables?; end
  def connection; end
  def migration_storage_names; end
  def pre_count?; end
  def tables_to_truncate(connection); end
end

DatabaseCleaner::ActiveRecord::VERSION = T.let(T.unsafe(nil), String)
DatabaseCleaner::VERSION = T.let(T.unsafe(nil), String)
