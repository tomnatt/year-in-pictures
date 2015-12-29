year-in-pictures
=========

Photos of the year.

Built using https://github.com/tomnatt/jekyll-foundation

Installation
------------

1. Clone to your chosen directory
1. `git submodule init`
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

1. Put an image in `images` (1020px wide)
1. Put a thumbnail in `images/thumbnails` (190px x 190px)
1. Update `images/_data.yml`
1. Add a corresponding `{picture}` in `index.html`

## Updating Foundation

Handling upgrades to git submodules using branches:

http://stackoverflow.com/questions/1777854/git-submodules-specify-a-branch-tag/18799234#18799234

## Todo

1. Update to Foundation 6

## People

1. Andrew
1. Dad
1. Dan
1. Ed
1. Ga
1. Hon
1. Kirsty
1. Lyns
1. Michael
1. Sheena
1. Shelley
1. Tom