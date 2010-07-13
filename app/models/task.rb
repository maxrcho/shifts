class Task < ActiveRecord::Base
  has_many :shifts_tasks
  has_many :shifts, :through => :shifts_tasks
  belongs_to :location
  
  validates_presence_of :name, :kind
  validate :start_less_than_end
  
  named_scope :active, lambda {{:conditions => {:active => true}}}
  named_scope :after_now, lambda {{:conditions => ["#{:end} >= #{Time.now.utc.to_sql}"]}}
  named_scope :in_locations, lambda {|loc_array| {:conditions => { :location_id => loc_array }}}
  named_scope :in_location, lambda {|location| {:conditions => { :location_id => location }}}
  named_scope :hourly, lambda {{:conditions => {:kind => "Hourly"}}}
  named_scope :daily, lambda {{:conditions => {:kind => "Daily"}}}
  named_scope :weekly, lambda {{:conditions => {:kind => "Weekly"}}}
  
  def done
    @last_completion = ShiftsTask.all.select{|st| st.task_id == self.id}.last
    if @last_completion
      hours_since = (Time.now - @last_completion.created_at)/3600
      if (self.kind == "Hourly") && (hours_since <= 1)
        return true
      elsif (self.kind == "Daily") && (hours_since <= 24)
        return true
      elsif (self.kind == "Weekly") && (hours_since <= 168)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  private
  
  def start_less_than_end
    errors.add(:start, "must be earlier than end time.") if (self.end <= start)
  end
end
