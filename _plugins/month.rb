class MonthMarkup < Liquid::Tag

  def initialize(tag_name, text, tokens)
    super
    params = text.split(" ")
    @month = params[0]
    @title_month = @month.slice(0,1).capitalize + @month.slice(1..-1)
  end

  def render(context)

<<-eos
  <section class="row month future" id="#{@month}">
    <h2>#{@title_month}</h2>
    <div class="images">
      <ul class="polaroids large-block-grid-3 small-block-grid-2">
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
        <li>
          <a title="placeholder" href="/photos/image-placeholder.html">
            <img alt="placeholder" src="/images/thumbnails/image-placeholder.png">
          </a>
        </li>
      </ul>
    </div>
  </section>
eos
  end

  Liquid::Template.register_tag "month", self

end
