class UsersController < ApplicationController
  def index
    @users = User.all.order("LOWER(first_name)")
    @teams = Team.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @users }
    end
  end

  def show
  end

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    respond_to do |format|
      format.json { head :ok }
      format.xml  { head :ok }
      format.html { redirect_to @user, :notice => "Team successfully updated"}
    end
  end

end
