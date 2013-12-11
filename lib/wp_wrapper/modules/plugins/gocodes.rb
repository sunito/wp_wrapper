module WpWrapper
  module Modules
    module Plugins
      module Gocodes
      
        def configure_gocodes(url_trigger = 'go')
          options   =   {
            :urltrigger               =>  {:value     =>  url_trigger,  :type   =>  :input}, 
            :nofollow                 =>  {:checked   =>  true,         :type   =>  :checkbox},
          }
        
          return set_options_and_submit("options-general.php?page=gocodes/gocodes.php", {:action => /page=gocodes\/gocodes\.php/i}, options)
        end
      
      end
    end
  end
end