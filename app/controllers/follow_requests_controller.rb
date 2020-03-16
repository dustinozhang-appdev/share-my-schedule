class FollowRequestsController < ApplicationController
  def index
    @follow_requests = FollowRequest.all.order({ :created_at => :desc })

    render({ :template => "follow_requests/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({:id => the_id }).at(0)

    render({ :template => "follow_requests/show.html.erb" })
  end

  def create
    @follow_request = FollowRequest.new
    @follow_request.recipient_id = params.fetch("query_recipient_id")
    @follow_request.sender_id = session[:user_id]
    recipient = User.where({:id => params["query_recipient_id"].to_i})[0]
    if (recipient.private == false)
      @follow_request.status = "accepted"
    else
      @follow_request.status = "pending"
    end

    if @follow_request.valid?
      @follow_request.save
      redirect_to("/users/#{recipient.username}")
    else
      redirect_to("/", { :notice => "Follow request failed to create successfully." })
    end
  end

  def update
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({ :id => the_id }).at(0)

    @follow_request.status = params.fetch("query_status")
    recipient = @follow_request.recipient

    if @follow_request.valid?
      @follow_request.save
      redirect_to("/users/#{recipient.username}")
    else
      redirect_to("/", { :alert => "Follow request failed to update successfully." })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    @follow_request = FollowRequest.where({ :id => the_id }).at(0)
    recipient = @follow_request.recipient
    @follow_request.destroy

    redirect_to("/users/#{recipient.username}")
  end
end
