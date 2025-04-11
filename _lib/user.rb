require_relative 'config'

class User
  def initialize(user_data)
    @id = user_data['id']
    @name = user_data['name']
  end

  # Add new or overwrite if already present
  def insert_sql
    'INSERT OR REPLACE INTO users (id,
                                   name)
      VALUES (?, ?)'
  end

  def values
    [@id, @name]
  end

  # Create year table
  def self.create_table_sql
    <<-SQL
      create table users (
        id INT UNIQUE PRIMARY KEY,
        name TEXT
      );
    SQL
  end
end
