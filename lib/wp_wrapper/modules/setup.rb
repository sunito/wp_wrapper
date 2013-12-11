module WpWrapper
  module Modules
    module Setup
    
      def setup(title, email)
        success       =   false
        setup_page    =   self.mechanize_client.open_url(get_url(:home))
      
        if (setup_page)
          setup_form  =   setup_page.form_with(:action => 'install.php?step=2')

          if (setup_form && title.present? && self.username.present? && self.password.present? && email.present?)
            puts "#{Time.now}: Url: #{self.url}. Setting up site..."

            setup_form.field_with(:name => 'weblog_title').value      =   title
            setup_form.field_with(:name => 'user_name').value         =   self.username
            setup_form.field_with(:name => 'admin_password').value    =   self.password
            setup_form.field_with(:name => 'admin_password2').value   =   self.password
            setup_form.field_with(:name => 'admin_email').value       =   email

            confirmation_page                                         =   setup_form.submit

            puts "#{Time.now}: Url: #{self.url}. The WordPress-blog has now been installed!"
            success                                                   =   true
          else
            puts "#{Time.now}: Url: #{self.url}. The blog has already been setup or the registration form couldn't be found or some data is missing."
            puts "#{Time.now}: Url: #{self.url}. Information supplied:\nTitle: #{title.inspect}.\nUsername: #{self.username.inspect}.\nPassword: #{self.password.inspect}.\nEmail: #{email.inspect}."
          end
        end
      
        return success
      end
    
      def set_permalinks_options(options = {})
        permalink_structure       =     options.fetch(:permalink_structure, '/%postname%/')
        category_base             =     options.fetch(:category_base, 'kategori')
        tag_base                  =     options.fetch(:tag_base, 'etikett')
      
        opt = {
          :custom_selection       =>  {:identifier => :id,              :checked => true,         :type => :radiobutton},
          :permalink_structure    =>  {:value => permalink_structure,   :type => :input},
          :category_base          =>  {:value => category_base,         :type => :input},
          :tag_base               =>  {:value => tag_base,              :type => :input},
        }
      
        return set_options_and_submit("options-permalink.php", {:action => 'options-permalink.php'}, options, :first, {:should_reset_radio_buttons => true})
      end

    end
  end
end