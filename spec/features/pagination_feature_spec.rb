require 'spec_helper'

describe "Simple pagination", :feature do
  it "activates without any issues" do   
    expect {
      run_site('recipes') { activate :pagination }
    }.not_to raise_error
  end

  it "produces pages for a set of resources" do
    run_site 'recipes' do
      activate :pagination do
        pageable_resource :recipes do |resource|
          resource.path.start_with?('recipes')
        end
      end
    end

    visit '/'
    find_on_page 'Showing 2 per page'
    find_on_page 'First page: /'
    find_on_page 'Last page: /pages/4.html'

    find_on_page 'Bacon'
    find_on_page 'Cake'
    find_on_page 'Page 1 of 4'
    find_on_page 'Prev page: none'
    find_on_page 'Next page: /pages/2.html'

    visit '/pages/2.html'
    find_on_page 'Gelato'
    find_on_page 'Mead'
    find_on_page 'Page 2 of 4'
    find_on_page 'Prev page: /'
    find_on_page 'Next page: /pages/3.html'

    visit '/pages/3.html'
    find_on_page 'Sandwich'
    find_on_page 'Waffles'
    find_on_page 'Page 3 of 4'
    find_on_page 'Prev page: /pages/2.html'
    find_on_page 'Next page: /pages/4.html'

    visit '/pages/4.html'
    find_on_page 'Yeti'
    find_on_page 'Page 4 of 4'
    find_on_page 'Prev page: /pages/3.html'
    find_on_page 'Next page: none'
  end
end

describe "Pagination with directory indexes", :feature do
  it "produces pages for a set of resources" do
    run_site 'recipes' do
      activate :pagination do
        pageable_resource :recipes do |resource|
          resource.path.start_with?('recipes')
        end
      end

      activate :directory_indexes
    end

    visit '/'
    find_on_page 'First page: /'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /pages/4/'
    find_on_page 'Next page: /pages/2/'

    visit '/pages/2/'
    find_on_page 'Prev page: /'
    find_on_page 'Next page: /pages/3/'

    visit '/pages/3/'
    find_on_page 'Prev page: /pages/2/'
    find_on_page 'Next page: /pages/4/'

    visit '/pages/4/'
    find_on_page 'Prev page: /pages/3/'
    find_on_page 'Next page: none'
  end
end

describe "Pagination with indexes not named index", :feature do
  it "produces pages for a set of resources" do
    run_site 'recipes' do
      activate :pagination do
        pageable_resource :recipes do |resource|
          resource.path.start_with?('recipes')
        end
      end
    end

    visit '/all-recipes.html'
    find_on_page 'First page: /all-recipes.html'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /all-recipes/pages/2.html'
    find_on_page 'Next page: /all-recipes/pages/2.html'

    visit '/all-recipes/pages/2.html'
    find_on_page 'Prev page: /all-recipes.html'
    find_on_page 'Next page: none'
  end
end

describe "Pagination with proxied resources and ignored proxy resource template", :feature do
  it "produces pages for a set of resources" do
    run_site 'mine' do
      %w{ Feldspar Olivine Quartz }.each do |mineral|
        proxy "/minerals/#{mineral.downcase}.html", '/minerals/template.html', locals: { mineral: mineral }, ignore: true
      end

      activate :pagination do
        pageable_resource :minerals do |resource|
          resource.path.start_with?('mineral')
        end
      end
    end

    visit '/'
    find_on_page 'Feldspar'
    find_on_page 'Olivine'
    find_on_page 'First page: /'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /pages/2.html'
    find_on_page 'Next page: /pages/2.html'

    visit '/pages/2.html'
    find_on_page 'Quartz'
    find_on_page 'Prev page: /'
    find_on_page 'Next page: none'
    expect(last_response.body).not_to include('minerals/template')
  end
end

describe "Pagination with proxied resources and ignored proxy index", :feature do
  it "produces pages for a set of resources" do
    run_site 'mine' do
      %w{ Feldspar Olivine Quartz }.each do |mineral|
        proxy "/minerals/#{mineral.downcase}.html", '/minerals/template.html', locals: { mineral: mineral }, ignore: true
      end

      proxy '/alternative/index.html', '/index.html', ignore: true

      activate :pagination do
        pageable_resource :minerals do |resource|
          resource.path.start_with?('mineral')
        end
      end
    end

    get '/'
    expect(last_response.status).to eql(404)

    get '/pages/2.html'
    expect(last_response.status).to eql(404)

    visit '/alternative/'
    find_on_page 'Feldspar'
    find_on_page 'Olivine'
    find_on_page 'First page: /alternative/'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /alternative/pages/2.html'
    find_on_page 'Next page: /alternative/pages/2.html'

    visit '/alternative/pages/2.html'
    find_on_page 'Quartz'
    find_on_page 'Prev page: /alternative/'
    find_on_page 'Next page: none'
  end
end

describe "Pagination with proxied resources and two indexes (one proxied)", :feature do
  it "produces pages for a set of resources" do
    run_site 'mine' do
      %w{ Feldspar Olivine Quartz }.each do |mineral|
        proxy "/minerals/#{mineral.downcase}.html", '/minerals/template.html', locals: { mineral: mineral }, ignore: true
      end

      proxy '/alternative/index.html', '/index.html'

      activate :pagination do
        pageable_resource :minerals do |resource|
          resource.path.start_with?('mineral')
        end
      end
    end

    visit '/'
    find_on_page 'Feldspar'
    find_on_page 'Olivine'
    find_on_page 'First page: /'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /pages/2.html'
    find_on_page 'Next page: /pages/2.html'

    visit '/pages/2.html'
    find_on_page 'Quartz'
    find_on_page 'Prev page: /'
    find_on_page 'Next page: none'

    visit '/alternative/'
    find_on_page 'Feldspar'
    find_on_page 'Olivine'
    find_on_page 'First page: /alternative/'
    find_on_page 'Prev page: none'
    find_on_page 'Last page: /alternative/pages/2.html'
    find_on_page 'Next page: /alternative/pages/2.html'

    visit '/alternative/pages/2.html'
    find_on_page 'Quartz'
    find_on_page 'Prev page: /alternative/'
    find_on_page 'Next page: none'
  end
end