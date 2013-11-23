require 'spec_helper'

describe "Pagination with custom path", :feature do
  it "produces pages for a set of resources with a custom path" do
    run_site 'recipes' do
      activate :pagination do
        pageable_resource :recipes do |resource|
          resource.path.start_with?('recipes')
        end
      end
    end

    visit '/custom.html'
    find_on_page 'First page: /custom.html'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /custom/p/2.html'
    find_on_page 'Next page: /custom/p/2.html'

    visit '/custom/p/2.html'
    find_on_page 'Prev page: /custom.html'
    find_on_page 'Next page: none'
  end
end