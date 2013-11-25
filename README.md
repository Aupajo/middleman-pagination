# Middleman Pagination

[![Build Status](https://travis-ci.org/Aupajo/middleman-pagination.png?branch=master)](https://travis-ci.org/Aupajo/middleman-pagination)
[![Code Climate](https://codeclimate.com/github/Aupajo/middleman-pagination.png)](https://codeclimate.com/github/Aupajo/middleman-pagination)
[![Dependency Status](https://gemnasium.com/Aupajo/middleman-pagination.png)](https://gemnasium.com/Aupajo/middleman-pagination)
[![Gem Version](https://badge.fury.io/rb/middleman-pagination.png)](http://badge.fury.io/rb/middleman-pagination)

General-purpose pagination support for Middleman.

Middleman resources, proxy pages, and any arbitrary collection of objects can be paginated.

## Installation

Add this line to your Middleman site's Gemfile:

```ruby
gem 'middleman-pagination'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman-pagination

## Usage

Let's say you have a set of recipes that you want to create pagination for:

    source/
        all-recipes.html
        recipes/
            apple-pie.html
            bacon.html
            cake.html

Inside your `config.rb`:

```ruby
activate :pagination do
  pageable_resource :recipes do |page|
    # Match any page that lives in the "recipes" directory
    page.path.start_with?('recipes/')
  end
end
```

**Note:** If you're using the directory indexes extension, place it *after* `activate :directory_indexes`.

Now, let's set up a *pagination index*. Inside `all-recipes.html`:

```erb
---
pagination:
  for: recipes
  per_page: 20
---

<% pagination.each do |recipe| %>
  - <%= link_to recipe.data.title, recipe.url %>
<% end %>

Page <%= pagination.page_num %> of <%= pagination.total_page_num %>

Showing <%= pagination.per_page %> per page

<%= link_to "First page", pagination.first_page.url %>

<%= link_to "Prev page", pagination.prev_page.url if pagination.prev_page %>

<%= link_to "Next page", pagination.next_page.url if pagination.next_page %>

<%= link_to "Last page", pagination.first_page.url %>
```

**Note:** the `for` and `per_page` properties must be indented for the `pagination` frontmatter (`per_page` is optional).

You can define as many different types of pageable resources as you like, with whatever criteria you like:

```ruby
activate :pagination do
  pageable_resource :staff do |page|
    # Match any page whose URL includes "/staff/"
    page.url.include?('/staff/')
  end

  pageable_resource :news do |page|
    # Match any page that has a "news" property in its frontmatter
    page.data.news.present?
  end
end
```

### Custom path

If your pagination index is called `all-recipes.html`, the subsequent pages will ba named `all-recipes/pages/2.html`, `all-recipes/pages/3.html`, and so on.

You can customise the path with the `path` pagination frontmatter. For example, in `all-recipes.html`:

```
---
pagination:
  for: recipes
  path: p/:num
---
```

Your pages would be created at `all-recipes/p/2.html`, `all-recipes/p/3.html`, etc.

## Paginate data

You aren't limited to just pages. You can paginate over [Middleman Local Data](http://middlemanapp.com/advanced/local-data/), too.

Let's say you had a file called `roman_gods.yml` in your `data` directory:

```
- name: Jupiter
  title: King of the Gods
- name: Juno
  title: Queen of the Gods
- name: Neptune
  title: God of the Sea
- name: Pluto
  title: God of Death

...snip...
```

You can produce pagination by using `pageable_set`:


```ruby
activate :pagination do
  pageable_set :gods do
    data.roman_gods
  end
end
```

In your template:

```erb
---
pagination:
  for: gods
  per_page: 10
---

<% pagination.each do |god| %>
  - <%= god.name %> (<%= god.title %>)
<% end %>

<%= link_to "Next page", pagination.next_page.url if pagination.next_page %>
```

## Paginate anything

In fact, you can paginate any collection of objects that responds to `each`, by using `pageable_set`:

```ruby
activate :pagination do
  pageable_set :planets do
    ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune']
  end
end
```

The set can be used in exactly the same way:

```erb
---
pagination:
  for: planets
  per_page: 4
---

Planets (showing <%= pagination.per_page %> per page):

<% pagination.each do |planet| %>
  - <%= planet %>
<% end %>

<%= link_to "Next page", pagination.next_page.url if pagination.next_page %>
```

## Getting help

Bug? Feature request? You can [open an issue](https://github.com/Aupajo/middleman-pagination/issues), [contact me on Twitter](http://twitter.com/aupajo), or [start a new topic on the Middleman forums](http://forum.middlemanapp.com). All feedback and suggestions welcome.

## TODO

* Custom sorting (e.g. by date)
* Add tests for metadata support
* Convenience helper methods (e.g. make `pagination.` optional)
* Pagination link generator (e.g. `Pages: 1 2 [3] ... 7 8 9`)
* Adopt Middleman's Queryable interface (potentially requires changes to Middleman first)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
