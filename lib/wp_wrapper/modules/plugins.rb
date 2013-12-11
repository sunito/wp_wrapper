module WpWrapper
  module Modules
    module Plugins
      include WpWrapper::Modules::Plugins::Akismet
      include WpWrapper::Modules::Plugins::Gocodes
      include WpWrapper::Modules::Plugins::W3TotalCache
      include WpWrapper::Modules::Plugins::WordpressSeo
      
      def manage_plugins(plugin_identifiers, action = :activate)
        plugin_identifiers        =   (plugin_identifiers.is_a?(Array)) ? plugin_identifiers : [plugin_identifiers.to_s]
        
        plugin_identifiers.each do |plugin_identifier|
          manage_plugin(plugin_identifier, action)
        end
      end
      
      def manage_plugin(plugin_identifier, action = :activate)
        success                   =   false
      
        if (login)
          activation_link         =   nil
          plugins_page            =   self.mechanize_client.open_url(get_url(:plugins))

          if (plugins_page)
            plugin_links          =   plugins_page.parser.css("table.plugins tbody tr td span.#{action} a")
            regex                 =   Regexp.new("plugin=#{plugin_identifier}", Regexp::Regexp::IGNORECASE)
        
            plugin_links.each do |link|
              href                =   link["href"]
          
              if (regex.match(href))
                activation_link   =   href
                break
              end
            end if (plugin_links && plugin_links.any?)
            
            if (activation_link && activation_link.present?)
              url                 =   "#{get_url(:admin)}/#{activation_link}"
              self.mechanize_client.open_url(url)
              puts "#{Time.now}: Url: #{self.url}. Plugin '#{plugin_identifier}' has been #{action}d!"
              success             =   true
            else
              puts "#{Time.now}: Url: #{self.url}. Couldn't find the plugin #{plugin_identifier}'s #{action}-link."
            end
            
          end
        else
          puts "#{Time.now}: Failed to login for url #{self.url}, will not proceed to #{action} plugins"
        end

        return success
      end

    end
  end
end