class UserProfileField < ActiveRecord::Base
  has_many :user_profile_entries, :dependent => :destroy
  has_one :department

  validates_presence_of :department_id
  validates_presence_of :display_type

  DISPLAY_TYPE_OPTIONS = {"Text Field"   => "text_field",
                          "Paragraph Text"    => "text_area",
                          "Select from a List"   => "select",
                          "Multiple Choice" => "radio_button",
                          "Check Boxes" => "check_box",
                          "Profile Picture (hyperlink)" => "picture_link"
                          }

  DISPLAY_TYPE_VIEW = {"text_field"   => "Text Field",
                        "text_area"    => "Paragraph Text",
                        "select"   => "Select from a List",
                        "radio_button" => "Multiple Choice",
                        "check_box" => "Check Boxes",
                        "picture_link" => "Profile Picture (hyperlink)"
                          }

  def prepare_form_helpers
    if display_type == "text_field"
      return ["user_profile_fields[#{id}]", id]
    elsif display_type == "picture_link"
      return ["user_profile_fields[#{id}]", id]
    elseif display_type == "upload_pic"
      return ["user_profile_fields[#{id}]", id]
    elsif display_type == "text_area"
      return ["user_profile_fields[#{id}]", id, {:id => id}]
    elsif display_type == "select"
      options = values.split(',').each{|opt| opt.squish!}
      return ["user_profile_fields[#{id}]", id, options.map{|opt| [opt, opt]}]
    elsif display_type == "check_box"
      options = values.split(',').each{|opt| opt.squish!}
      return options.map{|v| ["user_profile_entries[#{id}]", v]}
    elsif display_type == "radio_button"
      options = values.split(',').each{|opt| opt.squish!}
      return options.map{|v| ["user_profile_fields[#{id}]", 1, v]}
    end
  end


end

