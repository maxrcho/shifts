class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml

  def index
    @tasks = Task.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        flash[:notice] = 'Task was successfully created.'
        format.html { redirect_to(@task) }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Task was successfully updated.'
        format.html { redirect_to(@task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
  
  def make_entry
    #raise params.to_yaml
    @tasks = Task.in_location(current_user.current_shift.location).after_now
    @shift = current_user.current_shift
    
    params[:task_ids].each do |task_id|
      @shifts_task = ShiftsTask.new(:task_id => task_id, :shift_id => @shift.id )
  		@shifts_task.save
		end
		  if @report = current_user.current_shift.report
        @report.report_items << ReportItem.new(:time => Time.now, :content => "Completed  #{Task.find(@shifts_task.task_id).name} task.", :ip_address => request.remote_ip)
      end
    respond_to do |format|
      format.js
      format.html {redirect_to @report ? @report : @shift_task.data_object}
    end
    # flash[:notice] = 'Task has been completed.'
  end
  
  def update_tasks
    @tasks = Task.in_location(current_user.current_shift.location).after_now
    respond_to do |format|
      format.js
    end
  end


  def show_done_tasks
    @tasks = ShiftsTask.find_by_task_id(params[:id])
    @start_time = (params[:start_time].nil? ? 3.hours.ago.utc : Time.parse(params[:start_time]))
    respond_to do |format|
      format.js { }
      format.html { } #this is necessary!
    end
     @ShiftsTasks = ShiftsTask.after_time(@start_time).find(:all, :conditions => {:task_id => Task.find(@tasks.task_id)})

  end
  
  def missed_tasks
    @tasks = ShiftsTask.find_by_task_id(params[:id])
    @start_time = 5.hours.ago.utc
    @done_tasks = ShiftsTask.after_time(@start_time).find(:all, :conditions => {:task_id => Task.find(@tasks.task_id)}) 
    for f in (1..@done_tasks.size)      
      @done_tasks[f]
    #compare f to f+1 
    #d
    end
    respond_to do |format|
      format.js {}
      format.html { }      
    end    
    @ShiftsTasks = @done_tasks  .all.find(:all, :conditions => {:task_id => Task.find(:all).each})
  end

  
end
