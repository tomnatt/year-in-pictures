class PictureMarkup < Liquid::Tag
  require 'yaml'

  def initialize(tag_name, text, tokens)
    super
    params = text.split(' ')
    @image = params[0]
    @year = (params[1] ? params[1] : '2024')

    # read the config from a yml file
    index = nil
    data = YAML.load_file("images/#{@year}/_data.yml")['pictures']
    data.each_with_index do |pic, i|
      if pic['image'] == @image
        index = i
        break
      end
    end

    @link = File.basename(@image, File.extname(@image)) + '.html'
    @caption = data[index]['caption']
    @alt = data[index]['alt']
  end

  def render(_context)
<<-eos
  <li>
    <a title="#{@caption}" href="/photos/#{@year}/#{@link}">
      <img alt="#{@alt}" src="/images/#{@year}/thumbnails/#{@image}">
    </a>
  </li>
eos
  end

  Liquid::Template.register_tag 'picture', self
end
