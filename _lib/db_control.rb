require 'sqlite3'
require_relative 'config'

class DbControl
  # rubocop:disable Metrics/MethodLength
  def self.create
    db = SQLite3::Database.new Config.database_path unless File.exist? Config.database_path

    # Create picture table with multiple columns
    # unique_name is to give a unique identifier
    db.execute <<-SQL
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
  # rubocop:enable Metrics/MethodLength

  def self.delete
    File.delete Config.database_path
  end

  def self.add_all_pictures
    db = SQLite3::Database.open Config.database_path

    # Read each source file and add pictures to db
    Config.year_range.each do |year|
      pictures = YAML.load_file(Config.source_file_from_year(year))['pictures']
      pictures.each do |pic|
        # Add picture
        db.execute(insert_sql, sql_args(pic, year))
      end
    end
  end

  def self.update
    db = SQLite3::Database.open Config.database_path

    # Read this year's source file and add pictures to db
    pictures = YAML.load_file(Config.source_file_from_year(Config.latest_year))['pictures']
    pictures.each do |pic|
      # Add picture
      db.execute(insert_sql, sql_args(pic, Config.latest_year))
    end
  end

  # Add new or overwrite if already present
  def self.insert_sql
    'INSERT OR REPLACE INTO pictures (filename, title, caption, description, alt, month, year, unique_name)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
  end

  def self.sql_args(pic, year)
    unique_name = "#{pic['image']}#{pic['month']}#{year}"
    [pic['image'], pic['image_title'], pic['caption'], pic['description'], pic['alt'], pic['month'], year, unique_name]
  end
end
