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

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end

 # = MANIFEST =
 s.files = %w[

 ]
 # = MANIFEST =
