class HomeController < ApplicationController
  before_action :authenticate_user!
  helper HomeHelper

  def index
    @teams = Team.all.sort_by{ |t| t.name.downcase}
    @user = current_user
    @nfl_weeks = NflWeek.all
  end

end
