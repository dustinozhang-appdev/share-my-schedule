class CoursesController < ApplicationController
  def index
    @courses = Course.all.order({ :updated_at => :desc })
    @full = params["full"]
    @alreadyadded = params["alreadyadded"]
    @noslots = params["noslots"]
    @justadded = params["justadded"]
    render({ :template => "courses/index.html.erb" })
  end
  
  def add_to_schedule
    schedule = Schedule.where({:owner_id => @current_user.id})[0]
    course = Course.where({:id => params["id"]})[0]
    if course.maxcapacity == course.currentcount
      redirect_to("/courses?full=1")
      return
    end
    if (((course.id == schedule.course1 or course.id == schedule.course2) or course.id == schedule.course3) or course.id == schedule.course4)
      redirect_to("/courses?alreadyadded=1")
      return
    end
    if (schedule.course1 == nil)
      schedule.course1 = course.id
      course.currentcount = course.currentcount + 1
      course.save
      schedule.save
    elsif (schedule.course2 == nil)
      schedule.course2 = course.id
      course.currentcount = course.currentcount + 1
      course.save
      schedule.save
    elsif (schedule.course3 == nil)
      schedule.course3 = course.id
      course.currentcount = course.currentcount + 1
      course.save
      schedule.save
    elsif (schedule.course4 == nil)
      schedule.course4 = course.id
      course.currentcount = course.currentcount + 1
      course.save
      schedule.save
    else
      redirect_to("/courses?noslots=1")
      return
    end
    redirect_to("/courses?justadded=1") 
  end

  def remove_from_schedule
    schedule = Schedule.where({:owner_id => @current_user.id})[0]
    if (params["num"] == "1")
      courseID = schedule.course1
      course = Course.where({:id => courseID})[0]
      course.currentcount = course.currentcount - 1
      course.save
      schedule.course1 = nil
      schedule.save
    elsif (params["num"] == "2")
      courseID = schedule.course2
      course = Course.where({:id => courseID})[0]
      course.currentcount = course.currentcount - 1
      course.save
      schedule.course2 = nil
      schedule.save
    elsif (params["num"] == "2")
      courseID = schedule.course3
      course = Course.where({:id => courseID})[0]
      course.currentcount = course.currentcount - 1
      course.save
      schedule.course3 = nil
      schedule.save
    else
      courseID = schedule.course4
      course = Course.where({:id => courseID})[0]
      course.currentcount = course.currentcount - 1
      course.save
      schedule.course4 = nil
      schedule.save  
    end
    redirect_to("/users/#{@current_user.username}")
  end

  def show
    the_id = params.fetch("path_id")
    @course = Course.where({:id => the_id }).at(0)

    render({ :template => "courses/show.html.erb" })
  end

  def create
    @course = Course.new
    @course.professor = params.fetch("query_professor")
    @course.description = params.fetch("query_description")
    @course.name = params.fetch("query_name")
    @course.maxcapacity = params.fetch("query_max_capacity").to_i
    @course.currentcount = 0

    if @course.valid?
      @course.save
      redirect_to("/courses", { :notice => "Course created successfully." })
    else
      redirect_to("/courses", { :notice => "Course failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @course = Course.where({ :id => the_id }).at(0)

    @course.professor = params.fetch("query_professor")
    @course.description = params.fetch("query_description")
    @course.name = params.fetch("query_name")
    if params["maxcapacity"] != nil
      @course.capacity = params["maxcapacity"]
    end

    if @course.valid?
      @course.save
      redirect_to("/courses/#{@course.id}", { :notice => "Course updated successfully."} )
    else
      redirect_to("/courses/#{@course.id}", { :alert => "Course failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @course = Course.where({ :id => the_id }).at(0)

    @course.destroy

    redirect_to("/courses", { :notice => "Course deleted successfully."} )
  end
end
