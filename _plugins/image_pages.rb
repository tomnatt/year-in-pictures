module ImagePages

  class ImagePage < Jekyll::Page
    # An image page
    def initialize(site, base, dir, filename)
      @site = site
      @base = base
      @dir = dir

      f = File.basename(filename, File.extname(filename)) + '.html'
      @name = f # Name of the generated page

      # read the config from a yml file
      index = nil
      data = YAML.load_file('images/_data.yml')['pictures']
      data.each_with_index do |pic, i|
        if pic['image'] == filename
          index = i
          break
        end
      end

      unless index.nil?
        image_data = data[index]

        self.process(@name)
        self.read_yaml(File.join(@base, '_layouts'), 'picture.html')
        self.data['title'] = 'Year of the Sheep'
        self.data['months'] = 'false'
        self.data['month'] = image_data['month'].capitalize
        self.data['image'] = image_data['image']
        self.data['image_title'] = image_data['image_title']
        self.data['caption'] = image_data['caption']
        self.data['alt'] = image_data['alt']
      end
    end
  end

  class ImagePageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      Dir.foreach('/home/green/ruby/jekyll/yearinpictures/images') do |file|
        if file =~ /.jpg/ || file =~ /.png/
          new_page =  ImagePage.new(site, Dir.pwd, '/photos', file)
          site.pages << new_page
        end
      end
    end
  end

end