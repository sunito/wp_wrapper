module WpWrapper
  module Modules
    module Profiles
    
      def add_user(login, email, password, role = :editor, send_password = false)
        options   =   {
          :user_login     =>  {:value   => login,         :type => :input}, 
          :email          =>  {:value   => email,         :type => :input},
          :pass1          =>  {:value   => password,      :type => :input},
          :pass2          =>  {:value   => password,      :type => :input},
          :role           =>  {:value   => role,          :type => :select},
          :send_password  =>  {:checked => send_password, :type => :checkbox},
        }
      
        url       =   get_url(:new_user, absolute: false, admin_prefix: '')
      
        return set_options_and_submit(url, {name: "createuser"}, options)
      end
    
      def change_display_name(display_name)
        options   =   {
          :nickname         =>    {:value => display_name, :type => :input}
        }
        
        update_profile(options)
      
        options   =   {
          :display_name     =>    {:value => display_name, :type => :select}
        }
        
        update_profile(options)
      end
        
      def change_profile_password
        options   =   {
          :pass1    =>  {:value => new_password, :type => :input}, 
          :pass2    =>  {:value => new_password, :type => :input}
        }
      
        return update_profile(options)
      end
    
      def update_profile(options = {})
        url       =   get_url(:profile, absolute: false, admin_prefix: '')
      
        return set_options_and_submit(url, {action: /profile\.php/i}, options)
      end
    
      # Deprec?
      def change_profile_password(new_password)
        if (login)
          profile_page    =   self.mechanize_client.open_url(get_url(:profile))

          if (profile_page)
            profile_form  =   profile_page.form_with(:action => "#{self.site.url}/wp-admin/profile.php")
            profile_form.field_with(:name => 'pass1').value   =   new_password
            profile_form.field_with(:name => 'pass2').value   =   new_password
          
            updated_page  =   profile_form.submit(profile_form.buttons.first)
          end
        end
      end

    end
  end
end