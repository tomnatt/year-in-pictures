class PictureMarkup < Liquid::Tag

    def initialize(tag_name, text, tokens)
        super
        params = text.split(" ")
        @image = params[0]

        # read the config from a yml file?
        @caption = params[1]
        @alt = params[2]
    end

    def render(context)

<<-eos
<li>
    <a title="#{@caption}" href="#">
        <img alt="#{@alt}" src="/images/#{@image}">
    </a>
</li>
eos
    end

    Liquid::Template.register_tag "picture", self

end
