require 'sqlite3'
require_relative 'config'

class DbControl
  def self.create
    db = SQLite3::Database.new Config.database_path unless File.exist? Config.database_path

    # Create picture table with multiple columns
    db.execute <<-SQL
      create table pictures (
        filename TEXT,
        title TEXT,
        caption TEXT,
        description TEXT,
        alt TEXT,
        month TEXT
      );
    SQL
  end

  def self.delete
    File.delete Config.database_path
  end

  def self.add_pictures
    db = SQLite3::Database.open Config.database_path

    # Read each source file and add pictures to db
    Config.source_files.each do |file|
      pictures = YAML.load_file(file)['pictures']
      pictures.each do |pic|
        # Add picture
        db.execute('INSERT INTO pictures (filename, title, caption, description, alt, month) VALUES (?, ?, ?, ?, ?, ?)',
                   [pic['image'], pic['image_title'], pic['caption'], pic['description'], pic['alt'], pic['month']])
      end
    end
  end
end
