require 'spec_helper'

describe "Pagination with data", :feature do
  it "produces pages for a set of resources with a custom path" do
    run_site 'pantheon' do
      activate :pagination do
        pageable_set :gods do
          %w{ Ares Aphrodite Apollo Artemis Athena Demeter Hephaestus Hestia Zeus Hera Poseidon Hermes }
        end
      end
    end

    visit '/'
    find_on_page 'Ares'
    find_on_page 'Aphrodite'
    find_on_page 'Apollo'
    find_on_page 'Artemis'

    visit '/pages/2.html'
    find_on_page 'Athena'
    find_on_page 'Demeter'
    find_on_page 'Hephaestus'
    find_on_page 'Hestia'

    visit '/pages/3.html'
    find_on_page 'Zeus'
    find_on_page 'Hera'
    find_on_page 'Poseidon'
    find_on_page 'Hermes'
  end
end