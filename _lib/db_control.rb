require 'sqlite3'
require_relative 'config'
require_relative 'picture'

class DbControl
  def self.create
    db = SQLite3::Database.new Config.database_path unless File.exist? Config.database_path
    db.execute Picture.create_table_sql
  end

  def self.delete
    File.delete Config.database_path
  end

  def self.add_all_pictures
    add_pictures(Config.year_range)
  end

  def self.update
    # Eg range 2025 -> 2025
    add_pictures(Config.latest_year..Config.latest_year)
  end

  def self.add_pictures(year_range)
    db = SQLite3::Database.open Config.database_path

    # Read each source file and add pictures to db
    year_range.each do |year|
      pics_data = YAML.load_file(Config.source_file_from_year(year))['pictures']
      pics_data.each do |pic_data|
        pic = Picture.new(pic_data, year)
        db.execute(pic.insert_sql, pic.values)
      end
    end
  end
end
