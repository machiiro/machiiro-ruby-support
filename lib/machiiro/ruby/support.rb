require "machiiro/ruby/support/version"

require "active_support"

Dir.glob("#{File.dirname(__FILE__)}/support/**/*.rb").each do |e|
  require e
end
