class PivotalTrackerController < ApplicationController
  def index
    if current_user.tracker_token.present?
      tracker_api = TrackerAPI.new
      @tracker_project = params[:project_name]
      @tracker_stories = tracker_api.stories(current_user.tracker_token, params[:format])
    end
  end
end
