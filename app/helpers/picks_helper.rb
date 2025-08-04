module PicksHelper

  def nfl_teams_for_select
    # Show teams that player has not already picked
    picked_teams = Team.find_by_id(params[:team_id]).picks
    unpicked_teams = NflTeam.all.where.not(short_city: picked_teams.pluck(:nfl_team)).collect { |n| [n.full_name, n.short_city] }

    # Create array that includes all teams available to player
    available_teams = []
    # Only consider teams playing this week
    teams_playing_this_week = Game.where(week: set_current_week.to_s).collect { |t| [t.home, t.away] }.flatten
    # Eliminate games that have started
    started_games = Game.where("week = ? and scheduled_time <= ?", set_current_week.to_s, DateTime.current.to_s).collect { |g| [g.home, g.away] }.flatten
    # Make array of eligible games
    nfl_teams = teams_playing_this_week - started_games
    # Create array of NFL teams that only includes eligible games
    unpicked_teams.each do |full_name, short_city|
      nfl_teams.each do |team|
        if short_city == team
          available_teams << [full_name, short_city]
        end
      end
    end
    return available_teams.sort
  end

  def nfl_teams_for_edit
      pick = Pick.find_by_id(params[:id])
      picked_teams = Pick.all.where(team_id: pick.team_id)
      unpicked_teams = NflTeam.all.where.not(short_city: picked_teams.pluck(:nfl_team)).collect { |n| [n.full_name, n.short_city] }

      # Create array that includes all teams available to player
      edited_available_teams = []
      # Only consider teams playing this week
      teams_playing_this_week = Game.where(week: set_current_week.to_s).collect { |t| [t.home, t.away] }.flatten
      # Eliminate games that have started
      started_games = Game.where("week = ? and scheduled_time <= ?", set_current_week.to_s, DateTime.current.to_s).collect { |g| [g.home, g.away] }.flatten
      # Make array of eligible games
      nfl_teams = teams_playing_this_week - started_games
      # Create array of NFL teams that only includes eligible games
      unpicked_teams.each do |full_name, short_city|
        nfl_teams.each do |team|
          if short_city == team
            edited_available_teams << [full_name, short_city]
          end
        end
      end
      return edited_available_teams.sort
  end

  def no_pick_exists(team)
    week = NflWeek.where(["start_date <= ? and end_date >= ?", Date.current.to_s, Date.current.to_s]).last.week
    !team.picks.any?{|pick| pick.nfl_week == week}
  end

end
