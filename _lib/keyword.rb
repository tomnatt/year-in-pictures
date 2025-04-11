require_relative 'config'

class Keyword
  def initialize(keyword)
    @keyword = keyword
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO keywords (keyword) VALUES (?)'
  end

  def values
    [@keyword]
  end

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
