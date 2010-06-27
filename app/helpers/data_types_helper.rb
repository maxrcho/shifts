module DataTypesHelper
  def add_data_field_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :data_fields, :partial => 'data_field', :object => DataField.new
    end
  end
  
  def fields_for_data_field(data_field, &block)
    if data_field
      prefix = data_field.new_record? ? 'new' : 'existing'
      fields_for("data_type[#{prefix}_data_field_attributes][]", data_field, &block)
    end
  end

	def display_data_field_permissions(permissions)
		display = []
		display << "Admin" if permissions[0,1] == 'T'
		display << "Private" if permissions[1,1] == 'T'
		display << "Public" if permissions[2,2] == 'T'
		return display.to_sentence
	end
end
