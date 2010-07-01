class ShiftDuty < ActiveRecord::Base
  
  delegate :loc_group, :to => 'location'
  belongs_to :location
  belongs_to :calendar
  belongs_to :repeating_event
  has_many :shifts, :through => :location
  has_many :reports, :through => :shifts
  
  
  validates_presence_of :start, :end, :location_id
  validate :start_less_than_end
  validate :is_within_calendar
  
  named_scope :active, lambda {{:conditions => {:active => true}}}
  named_scope :in_locations, lambda {|loc_array| {:conditions => { :location_id => loc_array }}}
  named_scope :in_location, lambda {|location| {:conditions => { :location_id => location }}}
  named_scope :in_calendars, lambda {|calendar_array| {:conditions => { :calendar_id => calendar_array }}}
  
  
  
end
