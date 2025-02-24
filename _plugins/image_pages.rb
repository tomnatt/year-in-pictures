# frozen_string_literal: true

require './_lib/year_data'

module ImagePages
  # Generate individual image page, each instance called by iterator in ImagePageGenerator
  class ImagePage < Jekyll::Page
    # An image page
    def initialize(site, base, dir, filename, yaml_data, year)
      @site = site
      @base = base
      @dir = dir
      @name = get_generated_pagename(filename) # name of the generated page

      # read the config from a yml file
      index = nil
      yaml_data.each_with_index do |pic, i|
        if pic['image'] == filename
          index = i
          break
        end
      end

      image_data = yaml_data[index]

      process(@name)
      read_yaml(File.join(@base, '_layouts'), 'picture.html')

      data.merge!(year_specific_data(year))
      data.merge!(picture_specific_data(image_data))

      data['months'] = 'false' # omit global month navigation
      data['month'] = image_data['month'] # which month

      # next and previous pictures for navigtion
      data['next'] = next_picture(index, yaml_data)
      data['previous'] = previous_picture(index, yaml_data)
    end

    def get_generated_pagename(filename)
      "#{File.basename(filename, File.extname(filename))}.html"
    end

    def year_specific_data(year)
      data = { 'year' => year }

      case year
      when '2025'
        data['title'] = 'Year of the Snake'
        data['index'] = ''
      when '2024'
        data['title'] = 'Year of the Dragon'
        data['index'] = ''
      when '2023'
        data['title'] = 'Year of the Rabbit'
        data['index'] = '2023.html'
      when '2022'
        data['title'] = 'Year of the Tiger'
        data['index'] = '2022.html'
      when '2021'
        data['title'] = 'Year of the Ox'
        data['index'] = '2021.html'
      when '2020'
        data['title'] = 'Year of the Rat'
        data['index'] = '2020.html'
      when '2019'
        data['title'] = 'Year of the Pig'
        data['index'] = '2019.html'
      when '2018'
        data['title'] = 'Year of the Dog'
        data['index'] = '2018.html'
      when '2017'
        data['title'] = 'Year of the Rooster'
        data['index'] = '2017.html'
      when '2016'
        data['title'] = 'Year of the Monkey'
        data['index'] = '2016.html'
      when '2015'
        data['title'] = 'Year of the Sheep'
        data['index'] = '2015.html'
      else
        data['title'] = 'Year of the Unknown'
        data['index'] = ''
      end

      data
    end

    def picture_specific_data(picture_data)
      { 'image' => picture_data['image'],
        'photographer' => get_photographer_name(picture_data['image']),
        'image_title' => picture_data['image_title'],
        'description' => picture_data['description'],
        'alt' => picture_data['alt'] }
    end

    def get_photographer_name(filename)
      filename =~ /\d*-(.+)\..+/i
      # Capitalize for multiple people
      photographer_name = Regexp.last_match(1).split('-').map(&:capitalize).join(' and ')

      # Capitalize for single person with a surname
      # Will be wrong for multiple people with surnames
      photographer_name = photographer_name.split('_').map(&:capitalize).join(' ') if photographer_name.include?('_')

      photographer_name
    end

    def get_month_picture(index, picture_data, offset)
      # Get current month from the current picture
      current_month = picture_data[index]['month']

      # Filter pictures to only those in the same month
      month_pictures = picture_data.select { |pic| pic['month'] == current_month }

      # Find current index within month's pictures
      month_index = month_pictures.find_index { |pic| pic['image'] == picture_data[index]['image'] }

      # Get adjacent picture in month (with wrapping)
      adjacent_index = (month_index + offset) % month_pictures.length

      # Return the filename
      get_generated_pagename(month_pictures[adjacent_index]['image'])
    end

    def next_picture(index, picture_data)
      get_month_picture(index, picture_data, 1)
    end

    def previous_picture(index, picture_data)
      get_month_picture(index, picture_data, -1)
    end
  end

  # Iterate over all image files and generate page per image
  class ImagePageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      # images to omit
      omit_list = ['natural_paper.png']

      # iterate through all files in the directory
      ['', '2015', '2016', '2017', '2018', '2019', '2020', '2021', '2022', '2023', '2024', '2025'].each do |year|
        # Load YAML data once per year
        yaml_data = YearData.instance.year(year)

        Dir.foreach(File.join('images', year)) do |file|
          # only process image files and omit listed pictures
          if (file =~ /.jpg/ || file =~ /.png/) && !omit_list.include?(file)
            new_page = ImagePage.new(site, Dir.pwd, File.join('photos', year), file, yaml_data, year)
            site.pages << new_page
          end
        end
      end
    end
  end
end
