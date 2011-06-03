source 'http://rubygems.org'

gem 'rails', '3.0.7'

gem 'arel', '2.0.9'
gem 'rake', '0.8.7'

gem 'haml'
gem 'json'
gem 'simple_form'

platforms :jruby do
  gem 'jruby-openssl'
  gem 'activerecord-jdbc-adapter'
  gem 'jdbc-mysql'
  # gem 'activerecord-oracle_enhanced-adapter'

  gem 'mondrian-olap', :git => 'git://github.com/rsim/mondrian-olap.git'

  gem 'kirk', '~> 0.2.0.beta.4'
end

group :development, :test do
  gem 'awesome_print', :require => 'ap'
  gem "nifty-generators"
end
