module ImagePages

  class ImagePage < Jekyll::Page
    # An image page
    def initialize(site, base, dir, filename)
      @site = site
      @base = base
      @dir = dir

      f = File.basename(filename, File.extname(filename)) + '.html'
      @name = f # name of the generated page

      # the placeholder will have no year
      @year = (dir.split('/')[1] ? dir.split('/')[1] : '')

      # read the config from a yml file
      index = nil
      data = YAML.load_file(File.join('images', @year, '_data.yml'))['pictures']
      data.each_with_index do |pic, i|
        if pic['image'] == filename
          index = i
          break
        end
      end

      image_data = data[index]

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'picture.html')

      if @year == '2016'
        self.data['title'] = 'Year of the Monkey'
        self.data['index'] = ''
      elsif @year == '2015'
        self.data['title'] = 'Year of the Sheep'
        self.data['index'] = '2015.html'
      else
        self.data['title'] = 'Year of the Unknown'
        self.data['index'] = ''
      end

      self.data['months'] = 'false'
      self.data['month'] = image_data['month']
      self.data['year'] = @year
      self.data['image'] = image_data['image']
      self.data['photographer'] = image_data['image'][/([a-z]+)/, 1]
      self.data['image_title'] = image_data['image_title']
      self.data['description'] = image_data['description']
      self.data['alt'] = image_data['alt']
    end
  end

  class ImagePageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      # images to omit
      omit_list = ['natural_paper.png']

      # iterate through all files in the directory
      ['', '2015', '2016'].each do |year|
        Dir.foreach(File.join('images', year)) do |file|
          # only process image files
          if file =~ /.jpg/ || file =~ /.png/
            # omit listed pictures
            unless omit_list.include?(file)
              new_page =  ImagePage.new(site, Dir.pwd, File.join('photos', year), file)
              site.pages << new_page
            end
          end
        end
      end
    end
  end

end