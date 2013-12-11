# encoding: UTF-8

module WpWrapper
  module Modules
    module Plugins
      module WordpressSeo
      
        def configure_wordpress_seo(language = :sv)
          options                 =   {
            "wpseo_titles[forcerewritetitle]"   =>  {:type   =>  :checkbox,   :checked   =>  true},
            "wpseo_titles[title-home]"          =>  {:type   =>  :input,      :value     =>  '%%sitename%% %%page%%'},
            "wpseo_titles[title-search]"        =>  {:type   =>  :input,      :value     =>  translate_pattern(:search, language)},
            "wpseo_titles[title-404]"           =>  {:type   =>  :input,      :value     =>  translate_pattern(:not_found, language)},
          }
        
          standard_pattern        =   '%%title%% %%page%% %%sep%% %%sitename%%'
          standard_term_pattern   =   translate_pattern(:term, language)
        
          types                   =   {
            :post           =>  {:pattern => standard_pattern,                              :noindex => false},
            :page           =>  {:pattern => standard_pattern,                              :noindex => false},
            :attachment     =>  {:pattern => standard_pattern,                              :noindex => true},
            :wooframework   =>  {:pattern => standard_pattern,                              :noindex => false},
            :category       =>  {:pattern => standard_term_pattern,                         :noindex => false},
            :post_tag       =>  {:pattern => standard_term_pattern,                         :noindex => true},
            :post_format    =>  {:pattern => standard_term_pattern,                         :noindex => true},
            :author         =>  {:pattern => translate_pattern(:author, language),          :noindex => true},
            :archive        =>  {:pattern => '%%date%% %%page%% %%sep%% %%sitename%%',      :noindex => true},
          }
        
          types.each do |key, values|
            type_options = {
              "wpseo_titles[title-#{key}]"      =>  {:type   =>  :input,      :value      =>  values[:pattern]},
              "wpseo_titles[noindex-#{key}]"    =>  {:type   =>  :checkbox,   :checked    =>  values[:noindex]}
            }
          
            options.merge!(type_options)
          end
        
          login unless logged_in?

          url       =   "#{get_url(:admin)}/admin.php?page=wpseo_titles"
        
          page      =   self.mechanize_client.get_page(url)
          form      =   self.mechanize_client.get_form(page, {:action => /wp-admin\/options\.php/i})
        
          if (form)
            options.each do |key, values|
              case values[:type]
                when :input
                  form[key] = values[:value]
                when :checkbox
                  form[key] = "on" if values[:checked]
              end
            end
          
            form.submit
          end
        end
        
        def configure_wordpress_seo_sitemaps(not_included_post_types: [], not_included_taxonomies: [], disable_author_sitemap: true)
          login unless logged_in?

          url       =   "#{get_url(:admin)}/admin.php?page=wpseo_xml"
          page      =   self.mechanize_client.get_page(url)
          form      =   self.mechanize_client.get_form(page, {:action => /wp-admin\/options\.php/i})
          
          options   =   {
            "wpseo_xml[enablexmlsitemap]"                             =>  {:type   =>  :checkbox,   :checked    =>  true}
          }
          
          if (disable_author_sitemap)
            options["wpseo_xml[disable_author_sitemap]"]              =   {:type   =>  :checkbox,   :checked    =>  true}
          end
          
          not_included_post_types.each do |post_type|
            post_type_options = {
              "wpseo_xml[post_types-#{post_type}-not_in_sitemap]"     =>  {:type   =>  :checkbox,   :checked    =>  true}
            }
          
            options.merge!(post_type_options)
          end
          
          not_included_taxonomies.each do |taxonomy|
            taxonomy_options = {
              "wpseo_xml[taxonomies-#{taxonomy}-not_in_sitemap]"      =>  {:type   =>  :checkbox,   :checked    =>  true}
            }
            
            options.merge!(taxonomy_options)
          end
          
          if (form)            
            options.each do |key, values|
              case values[:type]
                when :input
                  form[key] = values[:value] if (form.has_field?(key))
                when :checkbox
                  form.checkbox_with(name: key).check rescue nil if values[:checked]
              end
            end
          
            form.submit
          end
        end
      
        #Retarded method for now, look into I18n later
        def translate_pattern(key, language = :en)
          case key
            when :search
              language.eql?(:sv) ? 'Du sökte efter %%searchphrase%% %%page%% %%sep%% %%sitename%%' : 'You searched for %%searchphrase%% %%page%% %%sep%% %%sitename%%'
            when :not_found
              language.eql?(:sv) ? 'Sidan kunde inte hittas %%sep%% %%sitename%%' : 'Page Not Found %%sep%% %%sitename%%'
            when :author
              language.eql?(:sv) ? '%%name%%, Författare %%sitename%% %%page%%' : '%%name%%, Author at %%sitename%% %%page%%'
            when :term
              language.eql?(:sv) ? '%%term_title%% Arkiv %%page%% %%sep%% %%sitename%%' : '%%term_title%% Archives %%page%% %%sep%% %%sitename%%'
          end
        end
      
      end
    end
  end
end