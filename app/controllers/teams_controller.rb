class TeamsController < ApplicationController
  before_action :authorize_user_for_delete, only: [:destroy]
  before_action :authorize_user_for_edit, only: [:edit]

  def index
    @user_teams = Team.where(user_id: current_user)


  end

  def show
    @team = Team.find(params[:id])
    @pick = Pick.where(team_id: @team.id)
  end

  def new
    @team = Team.new
  end

  def create
    @team = current_user.teams.build(team_params)

    if @team.save
      flash[:notice] = "Team successfully created."
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    @team.name = params[:team][:name]
    @team.verified = params[:team][:verified]

    if @team.save
      flash[:notice] = "Team successfully updated"
      redirect_to @team
    else
      render :edit
    end
  end

  def destroy
    @team = Team.find(params[:id])

    if @team.destroy
      flash[:notice] = "\"#{@team.name}\" was deleted successfully."
      redirect_to root_url
    else
      flash.now[:alert] = "There was an error deleting the team."
      render :show
    end
  end

  private
  def team_params
    params.require(:team).permit(:name)
  end

  def authorize_user_for_delete
    if DateTime.now > '2020-09-10'
      unless current_user.manager? || current_user.admin?
        flash[:alert] = "You must be a league manager to do that"
        redirect_to root_url
      end
    end
  end

  def authorize_user_for_edit
    team = Team.find(params[:id])
    unless current_user == team.user || current_user.manager? || current_user.admin?
      flash[:alert] = "You cannot edit another user's team"
      redirect_to root_url
    end
  end
end
