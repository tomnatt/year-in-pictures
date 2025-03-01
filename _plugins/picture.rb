require './_lib/db_control'

class PictureMarkup < Liquid::Tag
  def initialize(tag_name, text, tokens)
    super
    params = text.split
    @month = params[0]
  end

  def render(context)
    # Get the year from the page frontmatter and picture details from the db
    year = context.registers[:page]['year']
    pics = DbControl.get_month_pictures(@month, year)

    "#{head_html(year)}#{middle_html(pics, year)}#{foot_html}"
  end

  def head_html(year)
    <<-HEAD
  <section class="month" id="#{@month}">
    <h2><a href="##{@month}">#{@month.capitalize} #{year}</a></h2>
    <ul class="polaroids pure-g">
    HEAD
  end

  def middle_html(pics, year)
    middle = ''
    pics.each do |pic|
      middle += <<-ITERATOR
        <li class="pure-u-1-2 pure-u-sm-1-2 pure-u-lg-1-3">
          <a title="#{pic[2]}" href="/photos/#{year}/#{pic[0]}">
            <img loading="lazy" alt="#{pic[3]}" src="/images/#{year}/thumbnails/#{pic[1]}">
          </a>
        </li>
      ITERATOR
    end

    middle
  end

  def foot_html
    <<-FOOT
    </ul>
  </section>
    FOOT
  end

  Liquid::Template.register_tag 'picture', self
end
