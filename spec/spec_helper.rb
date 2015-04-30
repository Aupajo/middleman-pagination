require 'rspec'
require 'middleman/pagination'

# Include support files
support_files_pattern = File.expand_path('../support/**/*.rb', __FILE__)
Dir.glob(support_files_pattern).each { |f| require f }

RSpec.configure do |config|
  config.include MiddlemanServerHelpers, :feature
end
