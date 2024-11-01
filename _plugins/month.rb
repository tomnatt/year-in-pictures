class MonthMarkup < Liquid::Tag
  def initialize(tag_name, text, tokens)
    super
    params = text.split(' ')
    @month = params[0]
    @year = (params[1] ? params[1].to_i : Date.today.year)
    @people = (params[2] ? params[2].to_i : 6)
    @title_month = @month.sub(/^./, &:upcase)
  end

  def render(_context)
    output = <<-SNIPPET
  <section class="month future" id="#{@month}">
    <h2><a href="#{@month}">#{@title_month} #{@year}</a></h2>
    <ul class="polaroids pure-g">
    SNIPPET

    @people.times do
      output += <<-SNIPPET
        <li class="pure-u-1-2 pure-u-sm-1-2 pure-u-lg-1-3">
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img loading="lazy" alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
      SNIPPET
    end

    output += <<-SNIPPET
    </ul>
  </section>
    SNIPPET

    output
  end

  Liquid::Template.register_tag 'month', self
end
