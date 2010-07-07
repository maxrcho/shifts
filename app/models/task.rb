class Task < ActiveRecord::Base
  #has_and_belongs_to_many :shifts
  belongs_to :calendar
  belongs_to :location
  
  validates_presence_of :name, :kind
  validates_numericality_of :interval, :greater_than => 0
  validate :start_less_than_end
  validate :is_within_calendar
  
  named_scope :active, lambda {{:conditions => {:active => true}}}
  named_scope :after_now, lambda {{:conditions => ["#{:end} >= #{Time.now.utc.to_sql}"]}}
  
  private
  
  def start_less_than_end
    errors.add(:start, "must be earlier than end time.") if (self.end <= start)
  end
  
  def is_within_calendar
    unless self.calendar.default
      errors.add_to_base("Time slot start and end times must be within the range of the calendar.") if self.start < self.calendar.start_date || self.end > self.calendar.end_date
    end
  end
  
  
end
