require './_lib/config'
require './_lib/db_control'

module PhotographerGenerator
  class PhotographerPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.data['photographers'].each do |photographer|
        site.pages << PhotographerPage.new(site, photographer)
      end
    end
  end

  # rubocop:disable Metrics/MethodLength
  class PhotographerPage < Jekyll::Page
    def initialize(site, photographer)
      @site = site                                  # the current site instance
      @base = site.source                           # path to the source directory
      @dir  = Config.photographer_pages_dir         # the directory the page will reside in

      # Filenames
      @name = "#{photographer['id']}.html"          # output filename
      process(@name)                                # generate the other filename components

      pics = DbControl.get_photographer_pictures(photographer['id'])
      # "year" is the 5th element in the array
      pics_by_year = pics.group_by { |pic| pic[4] }

      # Define custom data - years and pics separate because liquid doesn't support hashes
      @data = {
        'layout' => 'photographer',
        'title' => "Photographs from #{photographer['name']}",
        'index' => 'photographers',
        'description' => photographer['name'],
        'years' => pics_by_year.keys,
        'pics' => pics_by_year
      }
    end
  end
  # rubocop:enable Metrics/MethodLength
end
