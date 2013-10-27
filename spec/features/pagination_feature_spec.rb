require 'middleman/pagination'
require 'middleman/rack'
require 'rack/test'

describe "Simple pagination" do
  include Rack::Test::Methods

  it "activates without any issues" do   
    run_site 'recipes' do
      activate :pagination
    end

    expect(get('/')).to be_ok
  end

  def app
    @app.call
  end

  def run_site(path, &block)
    ENV['MM_ROOT'] = File.expand_path("../../fixtures/#{path}", __FILE__)
    ENV['TEST'] = "true"

    @app = lambda do
      instance = Middleman::Application.server.inst do
        instance_exec(&block)
      end

      instance.class.to_rack_app
    end
  end
end