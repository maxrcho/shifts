class UserProfilesController < ApplicationController
before_filter :user_login
  def index
    @user_profiles = UserProfile.all.select{|profile| profile.user.is_active?(@department) }
  end

  def show
    @user_profile = UserProfile.find_by_user_id(User.find_by_login(params[:id]).id)
    unless @user_profile.user.departments.include?(@department)
      flash[:error] = "This user does not have a profile in this department."
    end
    @user_profile_entries = @user_profile.user_profile_entries.select{ |entry| entry.user_profile_field.department_id == @department.id && entry.user_profile_field.public }

  end

  def new
    @user_profile = UserProfile.new
  end

  def create
    @user_profile = UserProfile.new(params[:user_profile])
    if @user_profile.save && current_user.is_admin_of(@department)
      flash[:notice] = "Successfully created user profile."
      redirect_to @user_profile
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find_by_login(params[:id])
    @user_profile = UserProfile.find_by_user_id(@user.id)
    
    #The dept admin can edit all parts of any profile in their department, and a regular user can only edit their own profile entries that are user editable
    if current_user.is_admin_of?(@department)
      @user_profile_entries = @user_profile.user_profile_entries.select{ |entry| entry.user_profile_field.department_id == @department.id }
    elsif @user_profile.user == current_user
      @user_profile_entries = @user_profile.user_profile_entries.select{ |entry| entry.user_profile_field.department_id == @department.id && entry.user_profile_field.user_editable }
    else
      flash[:error] = "You are not allowed to edit another user's profile."
      redirect_to access_denied_path
    end
  end

  def update
    user = User.find(params[:id])
    @user_profile = UserProfile.find(params[:id])
    user_profile_entries = params[:user_profile_entries]
    @user_profile.update(user_profile_entries)
    redirect_to user_profile_path(@user)
  end

  def destroy
    @user_profile = UserProfile.find(params[:id])
    @user_profile.destroy
    flash[:notice] = "Successfully destroyed user profile."
    redirect_to user_profiles_url
  end

  def search
    users = current_department.active_users
    #filter results if we are searching
    if params[:search]
      params[:search] = params[:search].downcase
      @search_result = []
      users.each do |user|
        if user.login.downcase.include?(params[:search]) or user.name.downcase.include?(params[:search])
          @search_result << user
        end
      end
      users = @search_result.sort_by(&:last_name)
    end
    @user_profiles = []
    for user in users
      @user_profiles << UserProfile.find_by_user_id(user.user_id)
    end
  end
private
  def user_login
    @user_profile = UserProfile.find(:all, :conditions => {:user_id => User.find_by_login(params[:id])})
  end
end

