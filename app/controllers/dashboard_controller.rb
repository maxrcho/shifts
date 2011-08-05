class DashboardController < ApplicationController
  helper :shifts
  helper :data_entries
  helper :punch_clocks

  def index
    calculate_department_times
  	if params[:date].blank?
  		@current_date = Date.today
  	else
  		@current_date = params[:date]
  		@current_date = Date.parse(params[:date])
  	end
    @user = current_user
    @signed_in_shifts = Shift.signed_in(current_department).sort_by(&:start).group_by(&:loc_group)
    @upcoming_shifts = Shift.find(:all, :conditions => ["#{:user_id} = ? and #{:end} > ? and #{:department_id} = ? and #{:scheduled} = ? and #{:active} = ?", current_user, Time.now.utc, current_department.id, true, true], :order => :start, :limit => 5)

    @subs_you_requested = SubRequest.find(:all, :conditions => ["end > ? AND user_id = ?", Time.now.utc, current_user.id]).sort_by(&:start)
    @subs_you_can_take = current_user.available_sub_requests(@department).sort_by{|sub| sub.start}

    @watched_objects = DataObject.find(current_user.user_config.watched_data_objects.split(', ')).group_by(&:data_type)
    @current_notices = current_department.current_notices
  end

end
