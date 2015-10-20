class ActivityInstancesController < ApplicationController
  # GET /activities
  # GET /activities.json
  def index
    @activities_instances = ActivitiesInstance.occurrences_between(Date.parse('2013-01-01'),Date.parse('2013-04-30'))

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @activity_instances }
    end
  end

end