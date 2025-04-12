require_relative 'config'

class Metadata
  def initialize(user_data)
    @id = user_data['id']
    @name = user_data['name']
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO metadata (id,
                                   name)
      VALUES (?, ?)'
  end

  def values
    [@id, @name]
  end

  # Create year table
  def self.create_table_sql
    <<-SQL
      create table metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        picture TEXT, # link to unique_name
        poem TEXT,
        ai_description TEXT,
        keywords # TODO: join table
      );
    SQL
  end
end
