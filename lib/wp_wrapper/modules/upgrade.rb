module WpWrapper
  module Modules
    
    module Upgrade
    
      def upgrade(type = :core)
        success              =   self.send("upgrade_#{type}")

        puts "#{Time.now}: Will upgrade #{type} for site #{self.url}."

        if (success)
          puts "#{Time.now}: Successfully upgraded #{type} for site #{self.url}."
        end
      
        return success
      end
    
      def upgrade_core(retries: 3)
        success               =   false
      
        if (login)
          update_page         =   self.mechanize_client.open_url(get_url(:upgrade))
        
          if (update_page)
            response_header   =   update_page.parser.at_css('h3.response')
            upgrade_form      =   update_page.forms_with(:name => 'upgrade').try(:first)

            begin
              if (response_header && upgrade_form)
                puts "#{Time.now}: Url: #{self.url}. Upgrading WordPress..."
                upgraded_page =   upgrade_form.submit(upgrade_form.button_with(:name => 'upgrade'))
              
                puts "#{Time.now}: Url: #{self.url}. WordPress was upgraded!"
                success       =   true
              else
                puts "#{Time.now}: Url: #{self.url}. Will not upgrade WordPress, already at latest version."
                success       =   true
              end
            rescue Exception => e
              puts "#{Time.now}: Url: #{self.url}. An error occurred while trying to upgrade WordPress. Exception: #{e.class.name}. Message: #{e.message}. Stacktrace: #{e.backtrace.join("\n")}"
              retries        -=   1
              retry if (retries > 0)
            end
          end
        end

        return success
      end
    
      def upgrade_plugins
        return upgrade_themes_or_plugins(:plugins)
      end
    
      def upgrade_themes
        return upgrade_themes_or_plugins(:themes)
      end
    
      def upgrade_themes_or_plugins(type = :plugins, retries: 3)
        success                 =   false
        form_identifier         =   get_upgrade_form_identifier(type)
      
        if (login)
          update_page           =   self.mechanize_client.open_url(get_url(:upgrade))
        
          if (update_page)
            upgrade_form        =   update_page.form_with(:name => form_identifier)

            if (upgrade_form)
              puts "#{Time.now}: Url: #{self.url}. Upgrading #{type}..."

              upgrade_form.checkboxes.each do |checkbox|
                checkbox.checked = true
              end

              begin
                upgraded_page   =   upgrade_form.submit(upgrade_form.buttons.first)
                upgrade_url     =   upgraded_page.iframes.first.src
              
                puts "Upgrade #{type} url: #{upgrade_url.inspect}"

                if (upgrade_url)
                  self.mechanize_client.agent.get("#{get_url(:admin)}/#{upgrade_url}")
                  puts "#{Time.now}: Url: #{self.url}. #{type.to_s.capitalize} were upgraded!"
                  success       =   true
                end
              rescue Exception => e
                retries        -=   1
                retry if (retries > 0)
              end

            else
              puts "#{Time.now}: Url: #{self.url}. Will not upgrade any #{type}, they are all already at the latest version."
              success           =   true
            end
          end
        end
      
        return success
      end
    
      def upgrade_database
        success                 =   false
        response                =   self.http_client.retrieve_parsed_html(get_url(:admin)).parsed_body
      
        puts "#{Time.now}: Url: #{self.url}. Will check if database upgrades needs to be performed..."
      
        if (response)
          should_upgrade        =   !(response.at_css('body').content =~ /Database Update Required/i).nil?
        
          if (should_upgrade)
            puts "#{Time.now}: Url: #{self.url}. Should Upgrade WordPress database"
            upgrade_url         =   response.at_css("p.step a.button")['href']

            if (upgrade_url.present?)
              upgrade_url       =   "#{self.url}wp-admin/#{upgrade_url}" unless upgrade_url =~ /^http/i
              upgrade_response  =   self.http_client.retrieve_parsed_html(upgrade_url).parsed_body
              success           =   !(upgrade_response.at_css('body').content =~ /Update Complete/i).nil?
            
              puts "#{Time.now}: Url: #{self.url}. Successfully updated WordPress database." if success
            end
          end
        end
      
        return success
      end
    
      def get_upgrade_form_identifier(type = :plugins)
        return case type.to_sym
          when :plugins then 'upgrade-plugins'
          when :themes  then 'upgrade-themes' 
        end
      end

    end
    
  end
end