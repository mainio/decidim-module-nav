# Decidim::Nav

## Usage

This module provides a way to fully customize the Decidim navigation bar,
starting with an empty bar.

This is a fork of the great [Decidim::NavbarLinks](https://github.com/OpenSourcePolitics/decidim-module-navbar_links)
module which provided all the basics for building this module. This module
modifies the original functionality of the original module by removing all the
default links to provide full custom menu possibility. This also adds some extra
features, such as language specific links when needed.

The fork was created and the module was renamed to avoid confusion with the
original module. The development may diverge from the original module and we may
want to add extra features to it as well.

Admin view:
![Admin view](https://github.com/mainio/decidim-module-nav/blob/media/admin.png)

Homepage view:
![Home view](https://github.com/mainio/decidim-module-nav/blob/media/home.png)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'decidim-nav', github: "mainio/decidim-module-nav", branch: "main"
```

And then execute:

```bash
$ bundle
$ bundle exec rake decidim_nav:install:migrations
$ bundle exec rake db:migrate
```

## Contributing

See [Decidim](https://github.com/decidim/decidim).

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
