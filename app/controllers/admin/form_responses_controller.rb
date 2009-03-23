require 'ostruct'

class Admin::FormResponsesController < ApplicationController
  def index
    @form_names = FormResponse.find_by_sql("SELECT DISTINCT name FROM form_responses ORDER BY name").map { |fr| fr.name }  
  end  

  #Form Response Management
  def show_form
    # TODO: Any form of pagination
    @form_responses = FormResponse.find_by_name(params[:name])
    if @form_responses.nil? or (!@form_responses.nil? and @form_responses.size.eql?(0))
      redirect_to :action => "index"
    end
  end

  def delete_form_response
    if request.post?
      form_response = FormResponse.find(params[:id])
      form_name = form_response.name
      if form_response.destroy
        flash[:notice] = "Form response deleted successfully"
        redirect_to :action => "show_form", :name => form_name
      end
    end
  end

  # Export Form Responses
  def export
    options = { :order => "name, created_at" }
    
    if params[:filter]
      conditions = []
      conditions << "name = '#{params[:filter][:name]}'" if params[:filter][:name]
      conditions << "created_at >= '#{build_datetime_from_params(:start_time, params[:filter])}'" if params[:filter]['start_time(1i)']
      conditions << "created_at <= '#{build_datetime_from_params(:end_time, params[:filter])}'" if params[:filter]['end_time(1i)']
      options[:conditions] = conditions.join(" AND ")
    end
    @form_responses = FormResponse.find(:all, options)
    
    @exportable_fields = build_exportable_fields_from_params(params[:fields])
    @show_timestamps =  params[:options][:show_timestamps].eql?("1")
    @download_data = params[:options][:download_data].eql?("1")
    
    @exported_form = ''
    if params[:options][:format].eql?("XML")
      @exported_form = @form_responses.to_xml(:root => "form-responses", 
                                              :fields => @exportable_fields,
                                              :show_timestamps => @show_timestamps)
      if @download_data
        send_data(@exported_form, :type => "text/csv", :filename => params[:filter][:name] + ".csv")  
      else
        render(:xml => @exported_form)
      end
    elsif params[:options][:format].eql?("CSV")
      @form_responses.each do |form_response|
        @exported_form += form_response.to_csv(:fields => @exportable_fields, 
                                               :show_timestamps => @show_timestamps)
        @exported_form += "<br/>" unless @download_data
      end
      if @download_data
        send_data(@exported_form, :type => "text/csv", :filename => params[:filter][:name] + ".csv")  
      else
        render(:text => @exported_form)
      end      
    end
    
  end

  def export_form
    @export_formats = ["XML", "CSV"]
    @filter = OpenStruct.new(:name => "", :start_time => 7.days.ago, :end_time => Time.now)
    @form_response = FormResponse.find(:first, :conditions => ["name = ?", params[:name]], :limit => 1)
    @form_fields = []
    @form_response.content.each do |name, value|
      @form_fields << name
    end
  end

  protected

  # Reconstruct a datetime object from datetime_select helper form params
  def build_datetime_from_params(field_name, params)
    DateTime.new(params["#{field_name.to_s}(1i)"].to_i,
             params["#{field_name.to_s}(2i)"].to_i,
             params["#{field_name.to_s}(3i)"].to_i,
             params["#{field_name.to_s}(41)"].to_i,
             params["#{field_name.to_s}(5i)"].to_i).strftime('%Y-%m-%d %H:%M')
  end
  
  def build_exportable_fields_from_params(params)
    @exportable_fields = []
    params.each do |key, value|
      if value.eql?("1")
        @exportable_fields << key
      end
    end 
    
    return @exportable_fields
  end
end
