class UserProfile < ActiveRecord::Base

  belongs_to :user
  has_many :user_profile_entries
  
  def update(user_profile_entries, new_user_profile_entries)
    begin
      UserProfile.transaction do
        @failed = []
        user_profile_entries.each do |entry_id, entry_content|
          entry = UserProfileEntry.find(entry_id)
#          if entry == nil
#            entry = UserProfileEntry.new(id = entry_id, content = entry_content, created_at = Time.now, user_profile_id = @user_profile.id, user_profile_field_id = entry_id.field)
#          end
          @content = ""
          if entry.display_type == "check_box"
            UserProfileEntry.find(entry_id).values.split(", ").each do |value|
              c = entry_content[value]
              @content += value + ", " if c == "1"
            end
          @content.gsub!(/, \Z/, "")
          entry.content = @content
          @failed << entry.field_name unless entry.save

          elsif entry.display_type == "radio_button"
            entry.content = entry_content["1"]
            @failed << entry.field_name unless entry.save
          else
            entry.content = entry_content[entry_id]
            @failed << entry.field_name unless entry.save
          end
        end
        new_user_profile_entries.each do |field_id, entry_content|
          if entry_content
            entry = UserProfileEntry.new
            self.user_profile_entries << entry
            entry.user_profile_field_id = field_id
            @content = ""
            if entry.display_type == "check_box"
              UserProfileEntry.find(entry_id).values.split(", ").each do |value|
                c = entry_content[value]
                @content += value + ", " if c == "1"
              end
            @content.gsub!(/, \Z/, "")
            entry.content = @content
            @failed << entry.field_name unless entry.save
  
            elsif entry.display_type == "radio_button"
              entry.content = entry_content["1"]
              @failed << entry.field_name unless entry.save
            else
              entry.content = entry_content[field_id]
              @failed << entry.field_name unless entry.save
            end
          end
        end
      end
    end
  end
end

