module HomeHelper

  def week_status
    @nfl_weeks.each do |week|
      if Date.today >= week.start_date
        week.update(has_started: true)
      end

      if Date.today > week.end_date
        week.update(has_ended: true)
      end
    end
  end

  def lost_count(team)
    pick = Pick.where(team_id: team)
    pick.where(loss: true).count
  end

  def surviving_teams
    survivors = 0
    @teams.each do |team|
      if team.picks.where(loss: true).count < 1
        survivors += 1
      end
    end
    return survivors
  end

  def percent_survivors
    number_to_percentage((surviving_teams.to_f / @teams.count)*100, precision: 0)
  end

  def no_loss_teams
    no_loss_teams = 0
    @teams.each do |team|
      if team.picks.where(loss: true).count == 0
        no_loss_teams += 1
      end
    end
    return no_loss_teams
  end

  def percent_no_losers
    number_to_percentage((no_loss_teams.to_f / surviving_teams)*100, precision: 0)
  end

  def split_pot
    (@teams.count * 10)/surviving_teams
  end

  def authorize_user_for_pick(team)
    current_user == team.user || current_user.manager? || current_user.admin?
  end

  def deadline # sets deadline to Sat - in UTC - of current week
      current_week_end = NflWeek.where(["start_date <= ? and end_date >= ?", Date.current.to_s, Date.current.to_s]).last.end_date
      deadline = (current_week_end - 1) + 5.hours
      return deadline
  end
end