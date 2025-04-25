require 'active_record'
require 'sqlite3'
require_relative 'config'

class Year < ActiveRecord::Base
  # Create year table
  def self.create_table_sql
    <<-SQL
      create table years (
        year INT UNIQUE PRIMARY KEY,
        zodiac TEXT,
        homepage TEXT
      );
    SQL
  end

  def self.first_year
    db = SQLite3::Database.open Config.database_path
    year = db.execute 'select MIN(year) from years where year != 0;'
    # Output is [[year]] hence this
    year.first.first
  end

  def self.last_year
    db = SQLite3::Database.open Config.database_path
    year = db.execute 'select MAX(year) from years;'
    # Output is [[year]] hence this
    year.first.first
  end
end
