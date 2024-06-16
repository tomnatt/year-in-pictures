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
  <section class="row month future" id="#{@month}">
    <h2>#{@title_month} #{@year}</h2>
    <div class="images">
      <ul class="polaroids large-block-grid-3 small-block-grid-2">
    SNIPPET

    @people.times do
      output += <<-SNIPPET
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
      SNIPPET
    end

    output += <<-SNIPPET
      </ul>
    </div>
  </section>
    SNIPPET

    output
  end

  Liquid::Template.register_tag 'month', self
end
