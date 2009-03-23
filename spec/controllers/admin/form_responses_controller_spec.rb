require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::FormResponsesController do
  integrate_views
  
  scenario :users, :form_responses
  
  before :each do
    login_as :admin
  end

  it "should allow you to view the index" do
    get :index
    response.should be_success
  end
  
  it "should allow the index to render even when there are no form responses" do
    FormResponse.destroy_all
    get :index
    response.should be_success
  end
  
  it "should allow you to view the form responses for a form" do 
    get :show_form, :name => "form-alpha"
    response.should be_success
    response.should render_template('admin/form_responses/show_form')
  end
  
  it "should allow you to delete a form response" do
    
  end
  
  it "should allow you to export a form to xml" do
    
  end
  
  it "should allow you to export a form to csv" do
    
  end
  
  it "should allow you to export a form to downloadable file" do
    
  end
  
  it "should allow you to clear a form" do 
    
  end
  
end
