source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'rake'
  gem 'puppet', ENV['PUPPET_GEM_VERSION'] || '~> 4.5.0'
  gem 'rspec', '< 3.4.4'
  gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem 'puppetlabs_spec_helper'
  gem 'metadata-json-lint'
  gem 'rspec-puppet-facts'
  gem 'rubocop', '0.39.0'
  gem 'simplecov', '>= 0.11.0'
  gem 'simplecov-console'
  # Needed for ruby 2.1.8
  gem 'listen', '<= 3.0.6'

  gem 'puppet-lint-absolute_classname-check'
  gem 'puppet-lint-leading_zero-check'
  gem 'puppet-lint-trailing_comma-check'
  gem 'puppet-lint-version_comparison-check'
  gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
  gem 'puppet-lint-unquoted_string-check'
  gem 'puppet-lint-resource_reference_syntax'
end

group :development do
  gem 'travis'
  gem 'travis-lint'
  gem 'puppet-blacksmith'
  gem 'guard-rake'
end

group :system_tests do
  gem 'beaker'
  gem 'beaker-rspec'
  gem 'beaker-puppet_install_helper'
  gem 'vagrant-wrapper'
end
