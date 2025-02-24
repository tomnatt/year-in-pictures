class Picture
  attr_reader :filename, :title, :caption, :description, :alt, :month, :year

  def initialize(data, year)
    @filename = data['image']
    @title = data['image_title']
    @caption = data['caption']
    @description = data['description']
    @alt = data['alt']
    @month = data['month']
    @year = year
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO pictures (filename, title, caption, description, alt, month, year, unique_name)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
  end

  def values
    unique_name = "#{@filename}#{@month}#{@year}"
    [@filename, @image_title, @caption, @description, @alt, @month, @year, unique_name]
  end

  # Create picture table - unique_name is to give a unique identifier
  def self.create_table_sql
    <<-SQL
      create table pictures (
        filename TEXT,
        title TEXT,
        caption TEXT,
        description TEXT,
        alt TEXT,
        month TEXT,
        year INT,
        unique_name TEXT UNIQUE
      );
    SQL
  end
end
