require "machiiro/ruby/support/version"

require "active_support"
require "active_support/core_ext"
require "active_record"

Dir.glob("#{File.dirname(__FILE__)}/support/**/*.rb").each { |e| require e }
