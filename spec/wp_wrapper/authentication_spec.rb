require File.expand_path('../../spec_helper', __FILE__)

describe "Authentication using WpWrapper" do
  
  before(:each) do
    @client       =   init_admin_connection
  end
  
  it 'can successfully login given proper credentials' do
    @client.login.should == true
  end
  
  it 'can\'t login with invalid credentials' do
    invalid_client = init_invalid_connection
    invalid_client.login.should == false
  end

end
