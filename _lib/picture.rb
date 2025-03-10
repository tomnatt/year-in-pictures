class Picture
  def initialize(data, year, next_pic, prev_pic)
    @image_filename = data['image']
    @title = data['image_title']
    @caption = data['caption']
    @description = data['description']
    @alt = data['alt']
    @month = data['month']
    @photographer = data['photographer']
    @year = year
    @next = next_pic
    @prev = prev_pic

    # Calculated values
    @filename = generate_pagename
  end

  def generate_pagename
    "#{File.basename(@image_filename, File.extname(@image_filename))}.html"
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
        photographer INT,
        prev TEXT,
        next TEXT,
        unique_name TEXT UNIQUE,
        FOREIGN KEY (year) REFERENCES years (year),
        FOREIGN KEY (photographer) REFERENCES users (id)
      );
    SQL
  end

  # SQL to get all pictures for a given month and year
  def self.get_all_by_month(month, year)
    "SELECT filename, image_filename, caption, alt FROM pictures
     WHERE month='#{month}' and year=#{year} ORDER BY filename ASC;"
  end
end
