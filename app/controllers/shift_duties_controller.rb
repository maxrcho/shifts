class ShiftDutiesController < ApplicationController
  # GET /shift_duties
  # GET /shift_duties.xml
  def index
    @shift_duties = ShiftDuty.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shift_duties }
    end
  end

  # GET /shift_duties/1
  # GET /shift_duties/1.xml
  def show
    @shift_duty = ShiftDuty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shift_duty }
    end
  end

  # GET /shift_duties/new
  # GET /shift_duties/new.xml
  def new
    @shift_duty = ShiftDuty.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shift_duty }
    end
  end

  # GET /shift_duties/1/edit
  def edit
    @shift_duty = ShiftDuty.find(params[:id])
  end

  # POST /shift_duties
  # POST /shift_duties.xml
  def create
    @shift_duty = ShiftDuty.new(params[:shift_duty])

    respond_to do |format|
      if @shift_duty.save
        flash[:notice] = 'ShiftDuty was successfully created.'
        format.html { redirect_to(@shift_duty) }
        format.xml  { render :xml => @shift_duty, :status => :created, :location => @shift_duty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shift_duty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shift_duties/1
  # PUT /shift_duties/1.xml
  def update
    @shift_duty = ShiftDuty.find(params[:id])

    respond_to do |format|
      if @shift_duty.update_attributes(params[:shift_duty])
        flash[:notice] = 'ShiftDuty was successfully updated.'
        format.html { redirect_to(@shift_duty) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shift_duty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shift_duties/1
  # DELETE /shift_duties/1.xml
  def destroy
    @shift_duty = ShiftDuty.find(params[:id])
    @shift_duty.destroy

    respond_to do |format|
      format.html { redirect_to(shift_duties_url) }
      format.xml  { head :ok }
    end
  end
end
