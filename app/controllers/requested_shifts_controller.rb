class RequestedShiftsController < ApplicationController

  before_filter :require_proper_template_role

  # GET /requested_shifts
  # GET /requested_shifts.xml
  def index

	#copied from time_slot, some might not be necessary?
	@period_start = Date.today.previous_sunday
    #TODO:simplify this stuff:
    @dept_start_hour = current_department.department_config.schedule_start / 60
    @dept_end_hour = current_department.department_config.schedule_end / 60
    @hours_per_day = (@dept_end_hour - @dept_start_hour)
    @block_length = current_department.department_config.time_increment
    @blocks_per_hour = 60/@block_length.to_f
    @blocks_per_day = @hours_per_day * @blocks_per_hour
#definitely remove hidden timeslots
    @hidden_timeslots = [] #for timeslots that don't show up on the view

    if current_department.department_config.weekend_shifts #show weekends
      @day_collection = @period_start...(@period_start+7)
    else #no weekends
      @day_collection = (@period_start+1)...(@period_start+6)
    end

    @requested_shifts = RequestedShift.all
		@week_template = Template.find(:first, :conditions => {:id => params[:template_id]})
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @requested_shifts }
    end
  end

  # GET /requested_shifts/1
  # GET /requested_shifts/1.xml
  def show
    @requested_shift = RequestedShift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @requested_shift }
    end
  end

  def new
    @requested_shift = RequestedShift.new
		@week_template = Template.find(:first, :conditions => {:id => params[:template_id]})
		@shift_preference = current_user.shift_preferences.select{|sp| sp.template_id == @week_template.id}
		unless @shift_preference
			redirect_to new_template_shift_preference(@week_template)
		end
		#TODO: link these to Template timeslots?
		@time_start = Time.local(2000, "jan",1,8,0,0)
		@time_end = @time_start + 10.hours
		@locations = @week_template.locations
	end

  def edit
    @requested_shift = RequestedShift.find(params[:id])
		@template = Template.find(:first, :conditions => {:id => params[:template_id]})
		@locations = @template.locations
  end

  def create
    parse_just_time(params[:requested_shift])
    @requested_shift = RequestedShift.new(params[:requested_shift])
		@week_template = Template.find(params[:template_id])
		@requested_shift.template = @week_template
		@locations = @requested_shift.template.locations

		if params[:for_locations]
			@requested_shift.locations << Location.find(params[:for_locations])
		end
		@requested_shift.user = current_user
		respond_to do |format|
      if @requested_shift.save
        flash[:notice] = 'Requested shift was successfully created.'
        format.html { redirect_to(template_requested_shift_path(@week_template, @requested_shift)) }
        format.xml  { render :xml => @requested_shift, :status => :created, :location => @requested_shift }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @requested_shift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /requested_shifts/1
  # PUT /requested_shifts/1.xml
  def update
    @requested_shift = RequestedShift.find(params[:id])

    respond_to do |format|
      if @requested_shift.update_attributes(params[:requested_shift])
        flash[:notice] = 'RequestedShift was successfully updated.'
        format.html { redirect_to(@requested_shift) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @requested_shift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /requested_shifts/1
  # DELETE /requested_shifts/1.xml
  def destroy
    @requested_shift = RequestedShift.find(params[:id])
    @requested_shift.destroy

    respond_to do |format|
      format.html { redirect_to(template_requested_shifts_url) }
      format.xml  { head :ok }
    end
  end
end

private

  def parse_just_time(form_output)
    titles = ["preferred_start", "preferred_end", "acceptable_start","acceptable_end"]
    titles.each do |field_name|
      if !form_output["#{field_name}(5i)"].blank? && form_output["#{field_name}(4i)"].blank?
        form_output["#{field_name}"] = Time.parse( form_output["#{field_name}(5i)"] )
      end
      form_output.delete("#{field_name}(5i)")
    end
  end

