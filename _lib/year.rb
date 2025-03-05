require 'sqlite3'
require_relative 'config'

class Year
  def initialize(year_data)
    @year = year_data['year']
    @zodiac = year_data['zodiac']
    @homepage = year_data['homepage']
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO years (year,
                                   zodiac,
                                   homepage)
      VALUES (?, ?, ?)'
  end

  def values
    [@year, @zodiac, @homepage]
  end

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
