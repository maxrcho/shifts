class PayformSetsController < ApplicationController
  helper :payforms
  layout "payforms"

  before_filter :require_department_admin

  def index
    @payform_sets = PayformSet.all
  end

  def show
    @payform_set = PayformSet.find(params[:id])
    respond_to do |show|
      show.html #show.html.erb
      show.pdf  #show.pdf.prawn
      show.csv {render :text => @payform_set.payforms.to_csv(:template => :normal)}
    end
  end

  def create
    @payform_set = PayformSet.new
    @payform_set.department = current_department
    @payform_set.payforms = current_department.payforms.unprinted
    @payform_set.payforms.map {|p| p.printed = Time.now }
    if @payform_set.save
      @payform_set.payforms.each do |payform|
        raise @payform_set.payforms.to_yaml
       if payform.printed?
        email = ArMailer.create_printed_payforms_notification(payform)
        ArMailer.deliver(email)                 
       end
      end
      flash[:notice] = "Successfully created payform set."
      redirect_to @payform_set
    else
      flash[:notice] = "Error saving print job. Make sure approved payforms exist."
      redirect_to payforms_path
    end
  end
end
