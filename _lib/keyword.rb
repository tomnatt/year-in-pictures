require 'active_record'
require_relative 'config'

class Keyword < ActiveRecord::Base
  # Create year table - autoincrement id
  def self.create_table_sql
    <<-SQL
      create table keywords (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT
      );
    SQL
  end
end
