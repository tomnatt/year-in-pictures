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
    db = SQLite3::Database.open Config.database_path

    # Read each source file and add pictures to db
    Config.year_range.each do |year|
      pics_data = YAML.load_file(Config.source_file_from_year(year))['pictures']
      pics_data.each do |pic_data|
        pic = Picture.new(pic_data, year)
        db.execute(pic.insert_sql, pic.values)
      end
    end
  end

  def self.update
    db = SQLite3::Database.open Config.database_path

    # Read this year's source file and add pictures to db
    pics_data = YAML.load_file(Config.source_file_from_year(Config.latest_year))['pictures']
    pics_data.each do |pic_data|
      pic = Picture.new(pic_data, Config.latest_year)
      db.execute(pic.insert_sql, pic.values)
    end
  end
end
