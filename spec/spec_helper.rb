require "bundler/setup"
require 'simplecov'
SimpleCov.start do
  add_filter 'vendor/'
  add_filter 'spec/'
end

require 'active_support/time'
require 'active_support/time_with_zone'
require 'active_support/testing/time_helpers'
require "machiiro/ruby/support"

Time.zone = 'Asia/Tokyo'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include ActiveSupport::Testing::TimeHelpers
end
