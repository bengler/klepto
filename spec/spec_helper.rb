# encoding: utf-8
begin
  require 'simplecov'
rescue LoadError => e
  # ignore code coverage
end

require 'klepto'


RSpec.configure do |c|
  c.before :each do
    reset = Klepto.configuration_options.inject({}) do |options, o|
      options[o] = nil
      options
    end
    Klepto.configure(reset)
  end
end
