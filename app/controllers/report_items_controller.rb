class ReportItemsController < ApplicationController
  
  def create
    @report_item = ReportItem.new(params[:report_item])
    @report_item.time = Time.now
    @report_item.ip_address = request.remote_ip
    @report_item.report = params[:report_id] ? Report.find(params[:report_id]) : Shift.find(params[:shift_id]).report
    respond_to do |format|
      @report = Report.find(@report_item.report_id)
      if current_user==@report_item.user && @report_item.save
        @report.shift.stale_shifts_unsent = true
        @report.shift.save
        format.html {redirect_to @report}
        format.js
      else
        flash[:notice] = "You can't add things to someone else's report." if @report_item.user != current_user
        format.html {redirect_to @report}
        format.js {redirect_to @report}
      end
    end
  end
end

