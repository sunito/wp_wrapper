module WpWrapper
  module Options
    
    def set_blog_description(description)
      return set_options(:general, {:blogdescription => {:value => description, :type => :input}})
    end
    
    def disable_comments_and_trackbacks
      options   =   {
        :default_pingback_flag      =>  {:checked => false, :type => :checkbox}, 
        :default_ping_status        =>  {:checked => false, :type => :checkbox},
        :default_comment_status     =>  {:checked => false, :type => :checkbox},
        :comments_notify            =>  {:checked => false, :type => :checkbox},
        :moderation_notify          =>  {:checked => false, :type => :checkbox}
      }
      
      return set_options(:discussion, options)
    end
    
    def set_options(type, options = {})
      url = get_url("#{type}_options".to_sym, absolute: false, admin_prefix: '')
      return set_options_and_submit(url, {action: /options\.php/i}, options)
    end

  end
end