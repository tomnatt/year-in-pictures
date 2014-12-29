class PictureMarkup < Liquid::Tag

  require 'yaml'

  def initialize(tag_name, text, tokens)
    super
    params = text.split(" ")
    @image = params[0]

    # read the config from a yml file
    index = nil
    data = YAML.load_file('images/_data.yml')['pictures']
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

  def render(context)
<<-eos
  <li>
    <a title="#{@caption}" href="/photos/#{@link}">
      <img alt="#{@alt}" src="/images/#{@image}">
    </a>
  </li>
eos
  end

  Liquid::Template.register_tag "picture", self

end
