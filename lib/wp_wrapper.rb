module WpWrapper
  VERSION = "0.0.1"

  require File.join(File.dirname(__FILE__), 'wp_wrapper/railtie') if defined?(Rails)

  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/authorization')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/setup')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/upgrade')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/themes')
  
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/plugins/akismet')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/plugins/gocodes')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/plugins/w3_total_cache')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/plugins/wordpress_seo')
  
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/plugins')
  
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/options')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/profiles')
  require File.join(File.dirname(__FILE__), 'wp_wrapper/modules/api')
  
  require File.join(File.dirname(__FILE__), 'wp_wrapper/client')
end

