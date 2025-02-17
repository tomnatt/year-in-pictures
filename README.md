Year in pictures
=========

Photos of the year.

Built using [PureCSS](https://pure-css.github.io/) using Jekyll. Requires a Ruby environment with Bundler installed.

Installation
------------

1. Clone to your chosen directory
1. `bundle install`
1. `bundle exec rake serve`
1. http://localhost:4000/

SCSS files are in `_assets`.

To actually build the site from the command line, run:

```
bundle exec rake
```
## Credits

The photo stuff started life on [one of the Zurb example pages](http://zurb.com/playground/css3-polaroids).

## To add a picture

1. Put an image in `images` (1020px wide)
1. Put a thumbnail in `images/thumbnails` (190px x 190px)
1. Update `images/_data.yml`
1. Add a corresponding `{picture}` in `index.html`

## New year updates

1. Move `index.html` to `year.hml` (and commit)
1. Add new `index.html` file set up with new year
   * Make sure new list adds / removes photographers!
1. Create new `year/thumbnails` directory in `/images/`
1. Create `_data.yml` in `/images/year/` and remember to put `pictures:` at the top
1. Update side nav in `_layouts/layout.html`
1. Update year if / else and year array in `_plugins/image_pages.rb`
1. Add January photos as normal
