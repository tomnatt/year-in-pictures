require 'active_record'
require_relative 'config'

class Metadata < ActiveRecord::Base
  # Create year table
  def self.create_table_sql
    <<-SQL
      create table metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        picture TEXT, # link to unique_name
        poem TEXT,
        ai_description TEXT,
        -- keywords # TODO: join table
      );
    SQL
  end
end
