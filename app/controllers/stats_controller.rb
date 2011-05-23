class StatsController < ApplicationController
  def index
    return unless user_is_admin_of(current_department)
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : 1.week.ago.to_date
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : 1.day.ago.to_date
    
    @stats = {}
    
    # def average_shift_updates_hour #Could probably be optimized with better attribute -> sum handling
    #   myshifts = self.shifts.find(:all, :conditions => {:parsed => true})
    #   total_time = 0
    #   myshifts.each do |shift|
    #     total_time += shift.updates_hour
    #   end
    #   return total_time/myshifts.size
    # end
    
    users = current_department.active_users.sort_by(&:last_name)

    users.each do |u|
      user_stats = {}
      
      shifts = u.shifts.on_days(@start_date, @end_date).active

      user_stats[:name] = u.name
      
      user_stats[:num_shifts] = shifts.size
      user_stats[:num_late] = shifts.select{|s| s.late == true}.size
      user_stats[:num_missed] = shifts.select{|s| s.missed == true}.size
      user_stats[:num_left_early] = shifts.select{|s| s.left_early == true}.size
      valid_report_stats = shifts.select{|s| s.parsed == true}.collect(&:updates_hour).delete_if{|r| r == nil}
      if valid_report_stats.size == 0
        user_stats[:updates] = nil
      else
        user_stats[:updates] = valid_report_stats.sum/valid_report_stats.size
      end
      @stats[u.id] = user_stats
    end
  end
    

  # def index
  #     return unless user_is_admin_of(current_department)
  #     @start_date = params[:start_date] ? Date.parse(params[:start_date]) : 1.week.ago.to_date
  #     @end_date = params[:end_date] ? Date.parse(params[:end_date]) : 1.day.ago.to_date
  # 
  #     @stats = {}
  # 
  #     users = current_department.active_users.sort_by(&:last_name)
  # 
  #     users.each do |u|
  #       user_stats = {}
  #       
  #       shifts = u.shifts.on_days(@start_date, @end_date).active
  # 
  #       user_stats[:name] = u.name
  #       
  #       user_stats[:num_shifts] = shifts.size
  #       user_stats[:num_late] = shifts.select{|s| s.late?}.size
  #       user_stats[:num_missed] = shifts.select{|s| s.missed?}.size
  #       user_stats[:num_left_early] = shifts.select{|s| s.left_early?}.size 
  #       #user_stats[:scheduled_duration] = shifts.map{|s| s.duration(actual = false)}.sum
  #       #user_stats[:actual_duration] = shifts.map{|s| s.duration(actual = true)}.sum
  #               
  #       @stats[u.id] = user_stats
  #     end
  # end
end
