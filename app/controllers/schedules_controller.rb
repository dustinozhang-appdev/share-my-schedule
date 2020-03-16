class SchedulesController < ApplicationController
  def index
    public_ids = User.where({:private => false}).pluck(:id)
    @schedules = Schedule.where({ :owner_id => public_ids})

    render({ :template => "schedules/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @schedule = Schedule.where({:id => the_id }).at(0)

    render({ :template => "schedules/show.html.erb" })
  end

  def create
    @schedule = Schedule.new
    @schedule.owner_id = params.fetch("query_owner_id")

    if @schedule.valid?
      @schedule.save
      redirect_to("/schedules", { :notice => "Schedule created successfully." })
    else
      redirect_to("/schedules", { :notice => "Schedule failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @schedule = Schedule.where({ :id => the_id }).at(0)

    @schedule.owner_id = params.fetch("query_owner_id")

    if @schedule.valid?
      @schedule.save
      redirect_to("/schedules/#{@schedule.id}", { :notice => "Schedule updated successfully."} )
    else
      redirect_to("/schedules/#{@schedule.id}", { :alert => "Schedule failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @schedule = Schedule.where({ :id => the_id }).at(0)

    @schedule.destroy

    redirect_to("/schedules", { :notice => "Schedule deleted successfully."} )
  end
end
