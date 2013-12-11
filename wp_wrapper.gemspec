Gem::Specification.new do |s|
  s.specification_version     = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.name = 'wp_wrapper'
  s.version = '0.0.1'

  s.homepage      =   "http://github.com/Agiley/wp_wrapper"
  s.email         =   "sebastian@agiley.se"
  s.authors       =   ["Sebastian Johnsson"]
  s.description   =   "Wrapper to interact with WordPress using Mechanize"
  s.summary       =   "Wrapper to interact with WordPress using Mechanize"

  s.add_dependency "nokogiri", ">= 1.5.9"
  s.add_dependency "http_utilities", ">= 1.0.1"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  
  # = MANIFEST =
  s.files = %w[
  Gemfile
  LICENSE.txt
  README.markdown
  Rakefile
  lib/wp_wrapper.rb
  lib/wp_wrapper/client.rb
  lib/wp_wrapper/modules/api.rb
  lib/wp_wrapper/modules/authorization.rb
  lib/wp_wrapper/modules/options.rb
  lib/wp_wrapper/modules/plugins.rb
  lib/wp_wrapper/modules/plugins/akismet.rb
  lib/wp_wrapper/modules/plugins/gocodes.rb
  lib/wp_wrapper/modules/plugins/w3_total_cache.rb
  lib/wp_wrapper/modules/plugins/wordpress_seo.rb
  lib/wp_wrapper/modules/profiles.rb
  lib/wp_wrapper/modules/setup.rb
  lib/wp_wrapper/modules/themes.rb
  lib/wp_wrapper/modules/upgrade.rb
  lib/wp_wrapper/railtie.rb
  spec/spec_helper.rb
  spec/wordpress.yml.example
  spec/wp_wrapper/authentication_spec.rb
  wp_wrapper.gemspec
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end