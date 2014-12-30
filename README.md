year-in-pictures
=========

Photos of 2015 site

Built using https://github.com/tomnatt/jekyll-foundation

Installation
------------

1. Clone to your chosen directory
1. `submodule init`
1. `git submodule update`
1. `bundle install`
1. `bundle exec guard`
1. http://localhost:4000/

SCSS files are in _assets. You can dig any required Foundation javascript files out of the foundation directory.

To actually build the site from the command line, run:

```
bundle exec rake
```
## Credits

The photo stuff started life on [one of the Zurb example pages](http://zurb.com/playground/css3-polaroids).

## To add a picture

1. Put an image in `images` (_size_)
1. Put a thumbnail in `images/thumbnails` (190x190)
1. Update `images/_data.yml`
1. Add a corresponding `{picture}` in `index.html`

## Todo

* set up domain
* set up vhost
* redeploy with GA code
