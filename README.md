# Middleman Pagination

[![Build Status](https://travis-ci.org/Aupajo/middleman-pagination.png?branch=master)](https://travis-ci.org/Aupajo/middleman-pagination)
[![Code Climate](https://codeclimate.com/github/Aupajo/middleman-pagination.png)](https://codeclimate.com/github/Aupajo/middleman-pagination)
[![Dependency Status](https://gemnasium.com/Aupajo/middleman-pagination.png)](https://gemnasium.com/Aupajo/middleman-pagination)

**Warning: this extension is brand-new, and the API liable to change until the prerelease identifier is dropped.**

General-purpose pagination support for Middleman pages.

## Installation

Coming soon.

## Usage

Let's say you have a set of recipes that you want to create pagination for:

    source/
        all-recipes.html
        recipes/
            apple-pie.html
            bacon.html
            cake.html

You can create named pageable resources based on a criteria. In this case, we're going to use any page that lives inside the `recipes` as the criteria for paging through recipes. Inside your `config.rb`:

```ruby
activate :pagination do
  pageable :recipes do |page|
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
- <%= recipe.data.title %>
<% end %>

Page <%= pagination.page_num %> of <%= pagination.total_page_num %>

Showing <%= pagination.per_page %> per page

First page: <%= pagination.first_page.url %>

<% if pagination.prev_page %>
  Prev page: <%= pagination.prev_page.url %>
<% end %>

<% if pagination.next_page %>
  Next page: <%= pagination.next_page.url %>
<% end %>

Last page: <%= pagination.last_page.url %>
```

**Note:** the `for` and `per_page` properties must be indented for the `pagination` frontmatter.


You can define as many different types of pageable resources as you like:

```ruby
activate :pagination do
  pageable :staff do |page|
    # Match any page whose URL includes "/staff/"
    page.url.include?('/staff/')
  end

  pageable :news do |page|
    # Match any page that has "news" in its frontmatter
    page.data.news.present?
  end
end
```

## TODO

* Customisable path
* Custom sorting (e.g. by date)
* Convenience helper methods (e.g. make `pagination.` optional)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
