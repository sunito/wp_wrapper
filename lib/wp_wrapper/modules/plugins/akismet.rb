module WpWrapper
  module Modules
    module Plugins
      module Akismet
      
        def configure_akismet(api_key)
          options   =   {
            :key                      =>  {:value     =>  api_key,  :type   =>  :input}
          }
        
          return set_options_and_submit("plugins.php?page=akismet-key-config&show=enter-api-key", {:id => 'akismet-conf'}, options)
        end
      
      end
    end
  end
end