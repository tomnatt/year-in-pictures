require './_lib/config'

module PhotographerGenerator
  class PhotographerPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.data['photographers'].each do |photographer|
        site.pages << PhotographerPage.new(site, photographer)
      end
    end
  end

  class PhotographerPage < Jekyll::Page
    def initialize(site, photographer)
      @site = site                                  # the current site instance
      @base = site.source                           # path to the source directory
      @dir  = Config.photographer_pages_dir         # the directory the page will reside in

      # Filenames
      @name = "#{photographer['id']}.html"          # output filename
      process(@name)                                # generate the other filename components

      # Define any custom data you want.
      @data = {
        'layout' => 'photographer',
        'title' => "Photographs from #{photographer['name']}",
        'thingy' => 'Test words'
      }
    end
  end
end
