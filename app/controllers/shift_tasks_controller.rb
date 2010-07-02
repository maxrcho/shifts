class ShiftTasksController < ApplicationController
  # GET /shift_tasks
  # GET /shift_tasks.xml
  def index
    @shift_tasks = ShiftTask.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shift_tasks }
    end
  end

  # GET /shift_tasks/1
  # GET /shift_tasks/1.xml
  def show
    @shift_task = ShiftTask.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shift_task }
    end
  end

  # GET /shift_tasks/new
  # GET /shift_tasks/new.xml
  def new
    @shift_task = ShiftTask.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shift_task }
    end
  end

  # GET /shift_tasks/1/edit
  def edit
    @shift_task = ShiftTask.find(params[:id])
  end

  # POST /shift_tasks
  # POST /shift_tasks.xml
  def create
    @shift_task = ShiftTask.new(params[:shift_task])

    respond_to do |format|
      if @shift_task.save
        flash[:notice] = 'ShiftTask was successfully created.'
        format.html { redirect_to(@shift_task) }
        format.xml  { render :xml => @shift_task, :status => :created, :location => @shift_task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shift_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shift_tasks/1
  # PUT /shift_tasks/1.xml
  def update
    @shift_task = ShiftTask.find(params[:id])

    respond_to do |format|
      if @shift_task.update_attributes(params[:shift_task])
        flash[:notice] = 'ShiftTask was successfully updated.'
        format.html { redirect_to(@shift_task) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shift_task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shift_tasks/1
  # DELETE /shift_tasks/1.xml
  def destroy
    @shift_task = ShiftTask.find(params[:id])
    @shift_task.destroy

    respond_to do |format|
      format.html { redirect_to(shift_tasks_url) }
      format.xml  { head :ok }
    end
  end
end
