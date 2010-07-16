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
  
  #done shifts are crossed out in their locations
  def done
    @last_completion = ShiftsTask.all.select{|st| st.task_id == self.id}.last
    if @last_completion
      hours_since = (Time.now - @last_completion.created_at)/3600
      if (self.kind == "Hourly") && (hours_since < 1)
        return true
      elsif (self.kind == "Daily") && (hours_since < 24)
        return true
      elsif (self.kind == "Weekly") && (hours_since < 168)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  #delayed tasks show up as bold in their locations
  def needs_doing
    @last_completion = ShiftsTask.all.select{|st| st.task_id == self.id}.last
    if @last_completion
      hours_since = (Time.now - @last_completion.created_at)/3600
      hours_since_scheduled = (Time.now)
      if self.done
        return false
      elsif (self.kind == "Hourly") && (hours_since >= 1)
        return true
      elsif (self.kind == "Daily") && (self.right_time)
        return true
      elsif (self.kind == "Weekly") && ((self.right_time && self.right_day) || self.delayed_day)
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  #returns boolean if now is after scheduled time for task today; does not respect designated days for weekly tasks
  def right_time
    scheduled_time = self.time_of_day.seconds_since_midnight
    now_time = Time.now.seconds_since_midnight
    seconds_past_scheduled = now_time - scheduled_time
    if seconds_past_scheduled > 0
      return true
    elsif self.kind == "Hourly" #not extactly valid interpretation, since hourly tasks shouldn't have a time_of_day; to prevent nil value errors
      return true
    else
      return false
    end
  end
  
  #returns boolean if today is the correct day for a weekly task
  def right_day
    if self.day_in_week
      if self.day_in_week == Time.now.strftime("%a")
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  #returns boolean if a weekly task was supposed to be done yesterday; useful for flagging tasks that should have been done
  def delayed_day
    index_yesterday = Time.now.strftime("%w").to_i - 1
    if index_yesterday < 0
      index_yesterday = 6
    end
    abbreviation_array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    yesterday = abbreviation_array[index_yesterday]
    if yesterday == self.day_in_week
      return true
    else
      return false
    end
  end
  
  private
  
  def start_less_than_end
    errors.add(:start, "must be earlier than end time.") if (self.end <= start)
  end
end
