require_relative 'year'

class Config
  def self.database_path
    '_db/yip.db'
  end

  def self.years_path
    '_config/years.yml'
  end

  def self.unknown_pic_path
    '_config/unknown_pic.yml'
  end

  def self.year_range
    (Year.first_year..Year.last_year)
  end

  def self.source_file_from_year_path(year)
    "_db/data/#{year}.yml"
  end

  def self.get_generated_pagename(filename)
    "#{File.basename(filename, File.extname(filename))}.html"
  end

  def self.yaml_url(year)
    "#{ENV.fetch('YIP_RAILS_HELPER_LOCATION')}/year/#{year}?token=#{ENV.fetch('YIP_YEAR_TOKEN_PROD')}"
  end
end
