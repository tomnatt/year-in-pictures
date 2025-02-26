class Config
  def self.database_path
    '_db/yip.db'
  end

  def self.years_path
    '_config/years.yml'
  end

  # TODO: This type of config should be YAML?
  def self.first_year
    2015
  end

  def self.latest_year
    2025
  end

  def self.year_range
    (first_year..latest_year)
  end

  def self.source_file_from_year(year)
    "images/#{year}/_data.yml"
  end

  def self.get_generated_pagename(filename)
    "#{File.basename(filename, File.extname(filename))}.html"
  end
end
