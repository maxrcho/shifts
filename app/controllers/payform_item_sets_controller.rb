class PayformItemSetsController < ApplicationController
  layout "payforms"
  helper 'payforms'
  
  before_filter :require_department_admin
  
  # Shouldn't this filter by department?
  def index
    @payform_item_sets = PayformItem.group #todo -- determine if it is active or expired
  end
  
  def new
    @payform_item_set = PayformItem.new
    @users_select = current_department.active_users.sort_by(&:last_name)
  end
  
  def create
    params[:user_ids].delete("")
    @payform_item_set = PayformItem.new(params[:payform_item])
    @payform_item.group = true #this is a group_item
    date = build_date_from_params(:date, params[:payform_item])
    begin
      User.find(params[:user_ids]).each do |user| 
        @payform_item_set.payforms << Payform.build(current_department, user, date)
      end
      if @payform_item_set.save
        flash[:notice] = "Successfully created payform item set."
        redirect_to payform_item_sets_path
      else
        flash[:error] = @payform_item_set.errors.full_messages.to_sentence
        @users_select = current_department.users.sort_by(&:name)
        render :action => "new"
      end 
    rescue Exception => e
      flash[:error] = e.message
      @users_select = current_department.users.sort_by(&:name)
      render :action => "new"
    end
  end
  
  def edit
    @payform_item_set = PayformItem.find(params[:id])
    if @payform_item_set.group
      @users_select = current_department.users.sort_by(&:name)
    else
      flash[:error] = "Not a group job"
      redirect_to :action => "index"
    end
  end
  
  def update
    @payform_item_set = PayformItem.find(params[:id])
    params[:user_ids].delete("")
    date = build_date_from_params(:date, params[:payform_item])
    begin 
      @payform_item_set.payforms = [] #to be replaced by new list of users...
      User.find(params[:user_ids]).each do |user| 
        @payform_item_set.payforms << Payform.build(current_department, user, date)
      end
      if @payform_item_set.save
        flash[:notice] = "Successfully created payform item set."
        redirect_to payform_item_sets_path
      else
        flash[:error] = @payform_item_set.errors.full_messages.to_sentence
        @users_select = current_department.users.sort_by(&:name)
        render :action => "new"
      end 
    rescue Exception => e
      flash[:error] = e.message
      @users_select = current_department.users.sort_by(&:name)
      render :action => "edit"
    end
  end
  
  def destroy
    @payform_item_set = PayformItemSet.find(params[:id])
    if @payform_item_set.group
      @payform_item_set.active = false 
      @payform_item_set.save
    else
      flash[:error] = "Not a group job"
      redirect_to :action => "index"
    end
  end
  
  private
  
  def build_date_from_params(field_name, params)
    Date.new(params["#{field_name.to_s}(1i)"].to_i, 
             params["#{field_name.to_s}(2i)"].to_i, 
             params["#{field_name.to_s}(3i)"].to_i)
  end

end
