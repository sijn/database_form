class FormResponsesScenario < Scenario::Base
  
  def load
    create_form_response("form-alpha-1", { 
                                           :name => "form-alpha",
                                           :content => { 
                                                         :name => "first person", 
                                                         :telephone => "111-111-1111",
                                                         :email => "test@email.com"
                                                        }
                                         })
    create_form_response("form-alpha-2", { 
                                           :name => "form-alpha",
                                           :content => { 
                                                         :name => "second person", 
                                                         :telephone => "222-222-2222",
                                                         :email => "test@email.com"
                                                       }
                                         })
  end


  helpers do
    def create_form_response(entry_name, attributes={})
      create_model :form_response,
                   entry_name.symbolize,
                   form_response_params(attributes)
    end
    
    def form_response_params(attributes={})
      {
        :created_at => DateTime.now,
        :updated_at => DateTime.now
      }.merge(attributes)
    end
  end
  
end