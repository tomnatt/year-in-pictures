require './_lib/db_control'

class PictureMarkup < Liquid::Tag
  def initialize(tag_name, text, tokens)
    super
    params = text.split
    @image = params[0]
    @year = params[1] || Time.now.year

    # Get the picture details
    pic = DbControl.get_picture(@image, @year)

    @link = pic[0]
    @caption = pic[1]
    @alt = pic[2]
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
