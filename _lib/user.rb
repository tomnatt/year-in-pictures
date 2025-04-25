require 'active_record'
require_relative 'config'

class User < ActiveRecord::Base
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
