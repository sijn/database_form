class FormResponse < ActiveRecord::Base
  validates_presence_of :name, :content
  serialize :content, Hash

  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.tag!("form-response", :id => id) do
      xml.tag!("created-at", created_at.strftime("%Y-%m-%d %H:%M")) if options[:show_timestamps]
      content.each do |name, value|
        if(!options[:fields].nil? && options[:fields].include?(name))
          xml.tag!(name.dasherize, value)
        end
      end
    end
  end

  def to_csv(options = {})
    csv_output = ""
    content.each do |name, value|
      if(!options[:fields].nil? && options[:fields].include?(name))
        csv_output += created_at.strftime("%Y-%m-%d %H:%M") + "," if options[:show_timestamps]
        csv_output += value + ","
      end
    end
    return csv_output
  end
end
