require File.expand_path('../../spec_helper', __FILE__)

describe "Authentication using WpWrapper" do
  
  before(:each) do
    @client       =   init_wp_admin_connection
  end
  
  it 'can successfully login given proper credentials' do
    @client.login.should == true
  end

end
