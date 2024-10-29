require './lib/year_data'

class PictureMarkup < Liquid::Tag
  require 'yaml'

  def initialize(tag_name, text, tokens)
    super
    params = text.split(' ')
    @image = params[0]
    @year = (params[1] ? params[1] : '2024')

    # read the config from a yml file
    index = nil
    data = YearData.instance.year(@year)
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
<<-SNIPPET
  <li class="pure-u-1-2 pure-u-sm-1-2 pure-u-lg-1-3">
    <a title="#{@caption}" href="/photos/#{@year}/#{@link}">
      <img loading="lazy" alt="#{@alt}" src="/images/#{@year}/thumbnails/#{@image}">
    </a>
  </li>
SNIPPET
  end

  Liquid::Template.register_tag 'picture', self
end
