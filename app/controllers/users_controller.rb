class UsersController < ApplicationController
  # skip_before_action(:force_user_sign_in, { :only => [:new_registration_form, :create] })
  
  def index
    @users = User.all.order({ :username => :asc })
    @justsignedin = params["justsignedin"]
    @justsignedout = params["justsignedout"]
    @justcreated = params["justcreated"]
    @accessdenied = params["accessdenied"]
    render({ :template => "users/index.html" })
  end

  def show_detail
    if (session[:user_id] == nil) 
      redirect_to("/user_sign_in?accessdenied=1")
      return
    end
    
    username = params.fetch("username")
    @user = User.where({ :username => username }).at(0)
    viewer = User.where({ :id => session[:user_id] }).at(0)
    @feed = nil
    @own = 1
    render({ :template => "users/show.html.erb" })
  end

  def new_registration_form
    render({ :template => "user_sessions/sign_up.html.erb" })
  end

  def create
    @user = User.new
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    @user.username = params.fetch("query_username")
    if (params["query_private"] == nil)
      @user.private = false
    else 
      @user.private = true
    end

    save_status = @user.save

    if save_status == true
      session.store(:user_id,  @user.id)
      schedule = Schedule.new
      schedule.owner_id = @user.id
      schedule.save
   
      redirect_to("/?justcreated=1", { :notice => "User account created successfully."})
    else
      redirect_to("/user_sign_up", { :alert => "User account failed to create successfully."})
    end
  end
    
  def edit_registration_form
    render({ :template => "users/edit_profile.html.erb" })
  end

  def update
    @user = @current_user
    @user.email = params.fetch("query_email")
    @user.password = params.fetch("query_password")
    @user.password_confirmation = params.fetch("query_password_confirmation")
    if (params["query_private"] == nil)
      @user.private = false
    else 
      @user.private = true
    end
    @user.username = params["query_username"]
    
    if @user.valid?
      @user.save

      redirect_to("/", { :notice => "User account updated successfully."})
    else
      render({ :template => "users/edit_profile_with_errors.html.erb" })
    end
  end

  def update_small
    @user = @current_user
    if (params["query_private"] == nil)
      @user.private = false
    else 
      @user.private = true
    end
    @user.username = params["query_username"]
    
    @user.save
    redirect_to("/users/#{@user.username}")
  end

  def destroy
    schedule = Schedule.where({:owner_id => @current_user.id})[0]

    if (schedule.course1 != nil)
      course1 = Course.where({:id => schedule.course1})[0]
      course1.currentcount = course1.currentcount - 1
      course1.save
    end
    if (schedule.course2 != nil)
      course2 = Course.where({:id => schedule.course2})[0]
      course2.currentcount = course2.currentcount - 1
      course2.save
    end
    if (schedule.course3 != nil)
      course3 = Course.where({:id => schedule.course3})[0]
      course3.currentcount = course3.currentcount - 1
      course3.save
    end
    if (schedule.course4 != nil)
      course4 = Course.where({:id => schedule.course4})[0]
      course4.currentcount = course4.currentcount - 1
      course4.save
    end

    schedule.destroy
    @current_user.destroy
    reset_session
    
    redirect_to("/", { :notice => "User account cancelled" })
  end
  
end
