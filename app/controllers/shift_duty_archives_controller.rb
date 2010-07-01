class ShiftDutyArchivesController < ApplicationController
  # GET /shift_duty_archives
  # GET /shift_duty_archives.xml
  def index
    @shift_duty_archives = ShiftDutyArchive.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @shift_duty_archives }
    end
  end

  # GET /shift_duty_archives/1
  # GET /shift_duty_archives/1.xml
  def show
    @shift_duty_archive = ShiftDutyArchive.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @shift_duty_archive }
    end
  end

  # GET /shift_duty_archives/new
  # GET /shift_duty_archives/new.xml
  def new
    @shift_duty_archive = ShiftDutyArchive.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shift_duty_archive }
    end
  end

  # GET /shift_duty_archives/1/edit
  def edit
    @shift_duty_archive = ShiftDutyArchive.find(params[:id])
  end

  # POST /shift_duty_archives
  # POST /shift_duty_archives.xml
  def create
    @shift_duty_archive = ShiftDutyArchive.new(params[:shift_duty_archive])

    respond_to do |format|
      if @shift_duty_archive.save
        flash[:notice] = 'ShiftDutyArchive was successfully created.'
        format.html { redirect_to(@shift_duty_archive) }
        format.xml  { render :xml => @shift_duty_archive, :status => :created, :location => @shift_duty_archive }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shift_duty_archive.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shift_duty_archives/1
  # PUT /shift_duty_archives/1.xml
  def update
    @shift_duty_archive = ShiftDutyArchive.find(params[:id])

    respond_to do |format|
      if @shift_duty_archive.update_attributes(params[:shift_duty_archive])
        flash[:notice] = 'ShiftDutyArchive was successfully updated.'
        format.html { redirect_to(@shift_duty_archive) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shift_duty_archive.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shift_duty_archives/1
  # DELETE /shift_duty_archives/1.xml
  def destroy
    @shift_duty_archive = ShiftDutyArchive.find(params[:id])
    @shift_duty_archive.destroy

    respond_to do |format|
      format.html { redirect_to(shift_duty_archives_url) }
      format.xml  { head :ok }
    end
  end
end
