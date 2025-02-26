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
end
