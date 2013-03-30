ENV["RAILS_ENV"] ||= "test"
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rails/all'
require 'rspec/rails'

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'
  config.color_enabled = true
  config.tty = true
  config.use_transactional_fixtures = true
end

require File.expand_path("../test_app/config/environment", __FILE__)
require 'soft_delete'
