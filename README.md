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
