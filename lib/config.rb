class Config
  def self.database_path
    'db/yip.db'
  end

  # TODO: This type of config should be YAML?
  def self.first_year
    2015
  end

  def self.latest_year
    2025
  end

  def self.source_files
    (first_year..latest_year).map { |year| "images/#{year}/_data.yml" }
  end
end
