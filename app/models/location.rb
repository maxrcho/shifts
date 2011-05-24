class Location < ActiveRecord::Base
  belongs_to :loc_group

  named_scope :active, :conditions => {:active => true}
  named_scope :in_group, 
    lambda {|loc_group,*order| {
      :conditions => {:loc_group_id => loc_group.id},
      :order => order.flatten.first || 'priority ASC'                                  
  }}

  has_many :time_slots
	has_many :template_time_slots
  has_many :shifts
	has_many :locations_requested_shifts
	has_many :requested_shifts, :through => :locations_requested_shifts
  has_many :locations_shift_preferences
	has_many :shift_preferences, :through => :locations_shift_preferences
  has_and_belongs_to_many :data_objects
	has_and_belongs_to_many :requested_shifts

  validates_presence_of :loc_group
  validates_presence_of :name
  validates_presence_of :short_name
  validates_presence_of :min_staff
  validates_numericality_of :max_staff
  validates_numericality_of :min_staff
  validates_numericality_of :priority

  validates_uniqueness_of :name, :scope => :loc_group_id
  validates_uniqueness_of :short_name, :scope => :loc_group_id
  validate :max_staff_greater_than_min_staff

  delegate :department, :to => :loc_group

  def admin_permission
    self.loc_group.admin_permission
  end

  def locations
    [self]
  end

  def current_notices
		return self.announcements + self.stickies
#   ActiveRecord::Base.transaction do
#       a = LocationSinksLocationSource.find(:all, :conditions => ["location_sink_type = 'Notice' AND location_source_type = 'Location' AND location_source_id = #{self.id.to_sql}"]).collect(&:location_sink_id)
#       b = Sticky.active.collect(&:id)
#       c = Announcement.active.collect(&:id)
#       Notice.find(a & (b + c))
#     end

  end

  def stickies
     ActiveRecord::Base.transaction do
        a = LocationSinksLocationSource.find(:all, :conditions => ["location_sink_type = 'Notice' AND location_source_type = 'Location' AND location_source_id = #{self.id.to_sql}"]).collect(&:location_sink_id)
        b = Sticky.active.collect(&:id)
        Sticky.find(a & b).sort_by{|s| s.start}
      end
  end

  def announcements
     ActiveRecord::Base.transaction do
        a = LocationSinksLocationSource.find(:all, :conditions => ["location_sink_type = 'Notice' AND location_source_type = 'Location' AND location_source_id = #{self.id.to_sql}"]).collect(&:location_sink_id)
        b = Announcement.active.collect(&:id)
        Announcement.find(a & b).sort_by{|a| a.start}
      end
  end

  def links
     ActiveRecord::Base.transaction do
        a = LocationSinksLocationSource.find(:all, :conditions => ["location_sink_type = 'Notice' AND location_source_type = 'Location' AND location_source_id = #{self.id.to_sql}"]).collect(&:location_sink_id)
        b = Link.active.collect(&:id)
        Link.find(a & b) 
      end
  end

  def restrictions #TODO: this could probalby be optimized
    Restriction.current.select{|r| r.locations.include?(self)}
  end
  
  def deactivate
    self.active = false
    self.save!
    #Location activation must be set prior to individual shift activation; Shift class before_save
    shifts.after_date(Time.now.utc).update_all :active => false
  end
  
  def activate
    self.active = true
    self.save!
    #Location activation must be set prior to individual shift activation; Shift class before_save
    @shifts = shifts.after_date(Time.now.utc)
    @shifts.each do |shift|
      if shift.user.is_active?(shift.department) && shift.calendar.active
        shift.active = true
      end
      shift.save
    end    
  end

  def count_people_for(shift_list, min_block)
    people_count = {}
    people_count.default = 0
    unless shift_list.nil?
      shift_list.each do |shift|
        t = shift.start
        while (t<shift.end)
          people_count[t.to_s(:am_pm)] += 1
          t += min_block
        end
      end
    end
    people_count
  end

  protected

  def max_staff_greater_than_min_staff
    errors.add("The minimum number of staff cannot be larger than the maximum.", "") if (self.min_staff and self.max_staff and self.min_staff > self.max_staff)
  end
  
end

