module ImagePages
  class ImagePage < Jekyll::Page
    # An image page
    def initialize(site, base, dir, filename)
      @site = site
      @base = base
      @dir = dir
      @name = get_generated_pagename(filename) # name of the generated page

      year = get_year_from_dir(dir)
      yaml_data = YAML.load_file(File.join('images', year, '_data.yml'))['pictures']

      # read the config from a yml file
      index = nil
      yaml_data.each_with_index do |pic, i|
        if pic['image'] == filename
          index = i
          break
        end
      end

      image_data = yaml_data[index]

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'picture.html')

      self.data.merge!(year_specific_data(year))
      self.data.merge!(picture_specific_data(image_data))

      self.data['months'] = 'false' # omit global month navigation
      self.data['month'] = image_data['month'] # which month

      # next and previous pictures for navigtion
      self.data['next'] = next_picture(index, yaml_data)
      self.data['previous'] = previous_picture(index, yaml_data)
    end

    def get_generated_pagename(filename)
      File.basename(filename, File.extname(filename)) + '.html'
    end

    def get_year_from_dir(dir)
      # the placeholder will have no year
      dir.split('/')[1] ? dir.split('/')[1] : ''
    end

    def year_specific_data(year)
      data = { 'year' => year }

      if year == '2018'
        data['title'] = 'Year of the Dog'
        data['index'] = ''
      elsif year == '2017'
        data['title'] = 'Year of the Rooster'
        data['index'] = '2017.html'
      elsif year == '2016'
        data['title'] = 'Year of the Monkey'
        data['index'] = '2016.html'
      elsif year == '2015'
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
        'photographer' => picture_data['image'][/([a-z]+)/, 1],
        'image_title' => picture_data['image_title'],
        'description' => picture_data['description'],
        'alt' => picture_data['alt'] }
    end

    def next_picture(i, picture_data)
      # 'next' is 0 if we've hit the end of the data array
      i = (i + 1 < picture_data.length ? i + 1 : 0)
      get_generated_pagename(picture_data[i]['image'])
    end

    def previous_picture(i, picture_data)
      # array will wrap automatically
      get_generated_pagename(picture_data[i - 1]['image'])
    end
  end

  class ImagePageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      # images to omit
      omit_list = ['natural_paper.png']

      # iterate through all files in the directory
      ['', '2015', '2016', '2017', '2018'].each do |year|
        Dir.foreach(File.join('images', year)) do |file|
          # only process image files
          if file =~ /.jpg/ || file =~ /.png/
            # omit listed pictures
            unless omit_list.include?(file)
              new_page = ImagePage.new(site, Dir.pwd, File.join('photos', year), file)
              site.pages << new_page
            end
          end
        end
      end
    end
  end
end
