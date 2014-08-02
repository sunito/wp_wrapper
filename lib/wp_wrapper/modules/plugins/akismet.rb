module WpWrapper
  module Modules
    module Plugins
      module Akismet
      
        def configure_akismet(api_key)
          options     =   {
            :key                      =>  {:value     =>  api_key,  :type   =>  :input}
          }
        
          response    =   set_options_and_submit("options-general.php?page=akismet-key-config", {:id => 'akismet-enter-api-key'}, options)
        end
      
      end
    end
  end
end