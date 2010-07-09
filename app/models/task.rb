class Task < ActiveRecord::Base
  #has_and_belongs_to_many :shifts
  belongs_to :location
  
  validates_presence_of :name, :kind
  validates_numericality_of :interval, :greater_than => 0
  validate :start_less_than_end
  
  named_scope :active, lambda {{:conditions => {:active => true}}}
  named_scope :after_now, lambda {{:conditions => ["#{:end} >= #{Time.now.utc.to_sql}"]}}
  named_scope :in_locations, lambda {|loc_array| {:conditions => { :location_id => loc_array }}}
  named_scope :in_location, lambda {|location| {:conditions => { :location_id => location }}}
  named_scope :hourly, lambda {{:conditions => {:kind => "Hourly"}}}
  named_scope :daily, lambda {{:conditions => {:kind => "Daily"}}}
  named_scope :weekly, lambda {{:conditions => {:kind => "Weekly"}}}
  
  private
  
  def start_less_than_end
    errors.add(:start, "must be earlier than end time.") if (self.end <= start)
  end


  def accomplished
    
  end
end
