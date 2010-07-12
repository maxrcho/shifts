class PublicViewController < ApplicationController

  skip_before_filter :login_check
  skip_before_filter CASClient::Frameworks::Rails::Filter

  def index
    @date = Date.parse(params[:date])
    @location = Location.find_by_short_name(params[:location])
    
    @department = @location.department
    
    @shifts = Shift.active.on_day(@date).in_location(@location)     
		
 	  @start = @date.beginning_of_day + @department.department_config.schedule_start.minutes
		@end = @date.beginning_of_day + @department.department_config.schedule_end.minutes
		
		
		@time_array = []
		@current_time_block = @start
		while @current_time_block < @end do
		  @time_array << [@current_time_block, Shift.active.in_location(@location).overlaps(@current_time_block, @current_time_block + 1.minute)]
		  @current_time_block += @department.department_config.time_increment.minutes
	  end 
		@start = @date.beginning_of_day + @department.department_config.schedule_start.minutes
  end

end