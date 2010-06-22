module ReportsHelper
		# Customizes the thickbox height depending on how many data fields there are
	def link_to_update_data_object(report_data_object)
		height = report_data_object.data_fields.length * 150
		link_to "Update #{report_data_object.name}", new_data_object_data_entry_path(report_data_object, :height => height, :width => "500"), :title => "Update #{report_data_object.name}", :class => "thickbox", :onclick => "this.blur();"
	end
end

