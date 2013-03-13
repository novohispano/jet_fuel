require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/db/"
end

require './server'
require 'rack/test'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  config.order = 'random'
end