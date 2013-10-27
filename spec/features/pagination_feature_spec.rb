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
        pageable :recipes do |resource|
          resource.path.start_with?('recipes')
        end
      end
    end

    expect(get('/')).to be_ok
    expect(get('/pages/2.html')).to be_ok
    expect(get('/pages/3.html')).to be_ok
    expect(get('/pages/4.html')).to be_ok
  end
end