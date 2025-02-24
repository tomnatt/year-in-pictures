class Picture
  attr_reader :filename, :image_filename, :title, :caption, :description, :alt, :month, :year, :photographer

  def initialize(data, year)
    @image_filename = data['image']
    @title = data['image_title']
    @caption = data['caption']
    @description = data['description']
    @alt = data['alt']
    @month = data['month']
    @year = year

    # Calculated values
    @filename = generate_pagename
    @photographer = generate_photographer_name
  end

  def generate_pagename
    "#{File.basename(@image_filename, File.extname(@image_filename))}.html"
  end

  def generate_photographer_name
    @filename =~ /\d*-(.+)\..+/i
    # Capitalize for multiple people
    photographer_name = Regexp.last_match(1).split('-').map(&:capitalize).join(' and ')

    # Capitalize for single person with a surname
    # Will be wrong for multiple people with surnames
    photographer_name = photographer_name.split('_').map(&:capitalize).join(' ') if photographer_name.include?('_')

    photographer_name
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO pictures (filename,
                                      image_filename,
                                      title,
                                      caption,
                                      description,
                                      alt,
                                      month,
                                      year,
                                      photographer,
                                      unique_name)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
  end

  def values
    unique_name = "#{@filename}#{@month}#{@year}"
    [@filename, @image_filename, @image_title, @caption, @description, @alt, @month, @year, @photographer, unique_name]
  end

  # Create picture table - unique_name is to give a unique identifier
  def self.create_table_sql
    <<-SQL
      create table pictures (
        filename TEXT,
        image_filename TEXT,
        title TEXT,
        caption TEXT,
        description TEXT,
        alt TEXT,
        month TEXT,
        year INT,
        photographer TEXT,
        unique_name TEXT UNIQUE
      );
    SQL
  end
end
