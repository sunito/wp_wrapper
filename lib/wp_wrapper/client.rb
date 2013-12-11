module WpWrapper
  class Client
    attr_accessor :url, :username, :password
    attr_accessor :environment, :logged_in
    attr_accessor :http_client, :mechanize_client
    
    def initialize(options = {})
      options.symbolize_keys! if options.respond_to?(:symbolize_keys!)
      
      self.url                =   options.fetch(:url, nil)
      self.url                =   "#{self.url}/" if (!self.url.ends_with?("/"))
      
      self.username           =   options.fetch(:username, nil)
      self.password           =   options.fetch(:password, nil)
      self.environment        =   options.fetch(:environment, :production).to_sym
      self.logged_in          =   false
      
      self.http_client        =   HttpUtilities::Http::Client.new
      self.mechanize_client   =   HttpUtilities::Http::Mechanize::Client.new
    end
    
    include WpWrapper::Modules::Authorization
    include WpWrapper::Modules::Setup
    include WpWrapper::Modules::Upgrade
    include WpWrapper::Modules::Themes
    include WpWrapper::Modules::Plugins
    include WpWrapper::Modules::Options
    include WpWrapper::Modules::Profiles
    include WpWrapper::Modules::Api
    
    protected    
    def logged_in?
      return self.logged_in
    end
    
    def get_url(type  =   :home, options = {})
      absolute        =   options.fetch(:absolute, true)
      admin_prefix    =   options.fetch(:admin_prefix, "wp-admin/")
      uri             =   absolute ? self.url : ""

      return case type
        when :home                then    "#{uri}"
        when :admin               then    "#{uri}#{admin_prefix}"
        when :upgrade             then    "#{uri}#{admin_prefix}update-core.php"
        when :general_options     then    "#{uri}#{admin_prefix}options-general.php"
        when :write_options       then    "#{uri}#{admin_prefix}options-writing.php"
        when :read_options        then    "#{uri}#{admin_prefix}options-reading.php"
        when :discussion_options  then    "#{uri}#{admin_prefix}options-discussion.php"
        when :plugins             then    "#{uri}#{admin_prefix}plugins.php"
        when :themes              then    "#{uri}#{admin_prefix}themes.php"
        when :profile             then    "#{uri}#{admin_prefix}profile.php"
        when :new_user            then    "#{uri}#{admin_prefix}user-new.php"
      end
    end
    
    def set_options_and_submit(url, form_identifier = {}, fields = {}, submit_identifier = :first, options = {})
      login unless logged_in?
      
      form_page_url   =   "#{get_url(:admin)}/#{url}"
      response        =   self.mechanize_client.set_form_and_submit(form_page_url, form_identifier, submit_identifier, fields, options)
      
      #puts "Response: #{response.inspect}"
    end

  end
end