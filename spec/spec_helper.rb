require "rspec"
require "pry"
PROJECT_ROOT = File.expand_path('../..', __FILE__)

Dir["#{PROJECT_ROOT}/lib/**/*.rb"].each { |f| require f }

RSpec.configure { |config| config.color = true }
