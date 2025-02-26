class Picture
  def initialize(data, year, next_pic, prev_pic)
    @image_filename = data['image']
    @title = data['image_title']
    @caption = data['caption']
    @description = data['description']
    @alt = data['alt']
    @month = data['month']
    @year = year
    @next = next_pic
    @prev = prev_pic

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
  # rubocop:disable Metrics/MethodLength
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
                                      prev,
                                      next,
                                      unique_name)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)'
  end
  # rubocop:enable Metrics/MethodLength

  def values
    unique_name = "#{@filename}#{@month}#{@year}"
    [@filename, @image_filename, @title, @caption, @description,
     @alt, @month, @year, @photographer, @prev,
     @next, unique_name]
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
        year INT NOT NULL,
        photographer TEXT,
        prev TEXT,
        next TEXT,
        unique_name TEXT UNIQUE,
        FOREIGN KEY (year) REFERENCES years (year)
      );
    SQL
  end
end
