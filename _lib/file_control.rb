require 'open-uri'
require_relative 'config'
require_relative 'year'

class FileControl
  def self.download_all
    Config.year_range.each do |year|
      # Skip the early years - this predates the Rails application so no data there
      next if (2015..2018).include? year

      # Get the YAML from the app
      yaml_content = URI.parse(Config.yaml_url(year)).open.read
      # Save to disk
      File.write(Config.source_file_from_year_path(year), yaml_content)
    end
  end

  def self.download_latest
    year = Year.last_year
    # Get the YAML from the app
    yaml_content = URI.parse(Config.yaml_url(year)).open.read
    # Save to disk
    File.write(Config.source_file_from_year_path(year), yaml_content)
  end
end
