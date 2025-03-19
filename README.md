Year in pictures
=========

Photos of the year.

Built using [PureCSS](https://pure-css.github.io/) using Jekyll and Sqlite3. Requires a Ruby environment with Bundler installed and appropriate native Sqlite3 bindings / support. Image optimisation is done with `jpegoptim`. Up-to-date YAML is stored in this repo, but Rake task to udpate with new entries requires a [YiP Rails helper](https://github.com/tomnatt/year-in-pictures-rails-helper) running with location configured in and environment variable, or direct editing of YAML in `_db/data`.

Image sizes
-----------

Main images are 1020px wide. Thumbnails are 190px x 190px.

Environment variables
---------------------

Image copying:
* `YIP_IMAGE_SOURCE_DIR` - copy images and thumbnails from here (thumbnails stored as `YIP_IMAGE_SOURCE_DIR/thumbnails`)

Deployment:
* `HOSTING_USER` - remote server user
* `YEARINPICTURES_HOSTING_DIR` - remote server deploy location
* `DEPLOY_TARGET` - remote server location

Link to YiP Rails helper:
* `YIP_RAILS_HELPER_LOCATION` - base URL for helper
* `YIP_YEAR_TOKEN_PROD` - API key to access data

Installation
------------

1. Clone to your chosen directory
1. `bundle install`
1. `bundle exec rake db_create db_add_all_pictures`
1. `bundle exec rake serve`
1. http://localhost:4000/

SCSS files are in `_assets`.

To actually build the site from the command line, run:

```
bundle exec rake
```

## Credits

The photo stuff started life on [one of the Zurb example pages](http://zurb.com/playground/css3-polaroids).

## To add a new month of pictures

1. Run `bundle exec rake month_update` to download latest YAML, copy pics and optimise, update the database and run checks
1. Update `index.html` with new month
1. Build and check locally with `bundle exec rake serve`
1. Commit changes

## To update for a new year

1. Move `index.html` to `$year.html` (and commit)
1. Add new `index.html` file set up with new year
1. Create new `$year/thumbnails` directory in `/images/`
1. Add new year data block in `_config/jekyll_config.yml`
1. Add new year in `_config/years.yml` and rebuild database
1. Check [a short photographer page](http://localhost:4000/photographers/36.html) for length of RH menu
1. Add January photos as normal
