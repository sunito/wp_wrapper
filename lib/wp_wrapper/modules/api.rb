module WpWrapper
  module Api
          
    def enable_xml_rpc_api
      if (login)
        write_options_page = self.mechanize_client.open_url(get_url(:write_options))

        if (write_options_page)
          form = write_options_page.form_with(:action => /options\.php/i)
          form.checkbox_with(:name => 'enable_xmlrpc').checked = true
          
          updated_page = form.submit(form.buttons.first)
        end
      end
    end

  end
end