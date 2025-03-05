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

  def self.copy_pictures
    copy_main_pics
    copy_thumbnails
    optimise_thumbnails
  end

  def self.copy_main_pics
    pics = Dir["#{Config.image_source_directory(Config.last_month)}/*.jpg"]
    pics.each do |pic|
      FileUtils.cp(pic, Config.image_directory(Config.last_month))
    end
  end

  def self.copy_thumbnails
    pics = Dir["#{Config.thumbnails_source_directory(Config.last_month)}/*.jpg"]
    pics.each do |pic|
      FileUtils.cp(pic, Config.thumbnails_directory(Config.last_month))
    end
  end

  def self.optimise_thumbnails
    # Optimise the thumbnails with a command line script
    optimise_command = "jpegoptim -sq #{Config.thumbnails_directory(Config.last_month)}/*.jpg"
    system(optimise_command)
  end
end
