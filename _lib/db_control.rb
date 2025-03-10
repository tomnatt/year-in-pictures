require 'sqlite3'
require_relative 'config'
require_relative 'picture'
require_relative 'user'
require_relative 'year'

class DbControl
  def self.create
    db = SQLite3::Database.new Config.database_path unless File.exist? Config.database_path
    db.execute Picture.create_table_sql
    db.execute User.create_table_sql
    db.execute Year.create_table_sql

    # Add setup data
    add_years
    add_users
    add_unknown_pic
  end

  def self.delete
    File.delete Config.database_path
  end

  def self.add_all_pictures
    add_pictures(Config.year_range)
  end

  def self.update
    # Eg range 2025 -> 2025
    add_pictures(Year.last_year..Year.last_year)
  end

  def self.add_years
    db = SQLite3::Database.open Config.database_path

    years_data = YAML.load_file(Config.years_path)
    years_data.each do |year_data|
      year = Year.new(year_data)
      db.execute(year.insert_sql, year.values)
    end
  end

  def self.add_users
    db = SQLite3::Database.open Config.database_path

    users_data = YAML.load_file(Config.users_path)['users']
    users_data.each do |user_data|
      user = User.new(user_data)
      db.execute(user.insert_sql, user.values)
    end
  end

  def self.add_unknown_pic
    db = SQLite3::Database.open Config.database_path

    pic_data = YAML.load_file(Config.unknown_pic_path).first
    pic = Picture.new(pic_data, 0, '', '')
    db.execute(pic.insert_sql, pic.values)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.add_pictures(year_range)
    db = SQLite3::Database.open Config.database_path

    # Read each source file and add pictures to db
    year_range.each do |year|
      pics_data = YAML.load_file(Config.source_file_from_year_path(year))['pictures']
      # Get the pics by month { month => [ pics ] } to enable "next" and "previous"
      pics_by_month = pics_data.group_by { |pic| pic['month'] }

      pics_data.each do |pic_data|
        # Get the month's pictures array and find current pic index
        month_pics = pics_by_month[pic_data['month']]
        current_index = month_pics.find_index(pic_data)

        # Calculate next and previous indices with wrapping
        next_index = (current_index + 1) % month_pics.length
        prev_index = (current_index - 1) % month_pics.length

        # Get the filenames for next and previous pictures
        next_pic = Config.get_generated_pagename(month_pics[next_index]['image'])
        prev_pic = Config.get_generated_pagename(month_pics[prev_index]['image'])

        pic = Picture.new(pic_data, year, next_pic, prev_pic)
        db.execute(pic.insert_sql, pic.values)
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def self.get_month_pictures(month, year)
    db = SQLite3::Database.open Config.database_path
    db.execute(Picture.get_all_by_month(month, year))
  end
end
