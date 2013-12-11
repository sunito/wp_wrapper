$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Your bundler version is too old." +
     "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run \`bundlee install\`?"
end

Bundler.require

require File.expand_path('../../lib/wp_wrapper', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
end

def load_config
  config = YAML.load_file((File.exists?('./wordpress.yml')) ? './wordpress.yml' : './wordpress.yml.example')
  config.symbolize_keys! if config.respond_to?(:symbolize_keys!)
  
  return config
end

def init_admin_connection
  config = load_config
  WpWrapper::Client.new(config[:admin])
end

def init_invalid_connection
  config = load_config
  WpWrapper::Client.new(config[:invalid])
end