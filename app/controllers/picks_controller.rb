class PicksController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user_for_edit, only: [:edit]

  def index
    @picks = Pick.all

    respond_to do |format|
      format.html
      format.csv { send_data @picks.to_csv}
    end
  end

  def new
    @team = Team.find(params[:team_id])
    @pick = Pick.new

  end

  def create
    @team = Team.find(params[:team_id])
    @pick = @team.picks.create(pick_params)

    if @pick.save
      flash[:notice] = "Pick submitted"
      redirect_to root_url
    else
      flash.now[:alert] = "There was an error submitting your pick. Please try again."
      render :new
    end
  end

  def edit
    @pick = Pick.find(params[:id])
  end

  def update
    @team = Team.find(params[:team_id])
    @pick = Pick.find(params[:id])
    @pick.assign_attributes(pick_params)
    associate_pick_game

    if @pick.save
      flash[:notice] = "Pick successfully updated"
      redirect_to root_url
    else
      flash.now[:alert] = "There was an error saving your change. Please try again."
      render :edit
    end
  end

  private
  def pick_params
    params.require(:pick).permit(:team_id, :nfl_week, :nfl_team)
  end

  def authorize_user_for_edit
    pick = Pick.find(params[:id])
    team = Team.find(pick.team_id)
    unless current_user == team.user || current_user.manager? || current_user.admin?
      flash[:alert] = "You cannot edit another user's pick"
      redirect_to root_url
    end
  end

  def associate_pick_game
    weeks_games = Game.where(week: @pick.nfl_week)
    game_id = weeks_games.where(["home = ? or away = ?", @pick.nfl_team, @pick.nfl_team]).last.id
    @pick.update_attributes(game_id: game_id)
  end
end
