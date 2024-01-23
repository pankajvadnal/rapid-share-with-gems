require 'simplecov'

SimpleCov.start 'rails' do
  add_filter 'config/'
  add_filter 'spec/'
  # Add other configuration options here
end
