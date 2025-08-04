module TeamsHelper
  def lost_count(team)
    pick = Pick.where(team_id: team)
    pick.where(loss: true).count
  end

  def no_pick_exists(team)
    if !NflWeek.first.has_started?
      week = 1
    elsif
      week = NflWeek.where(["start_date <= ? and end_date >= ?", Date.current.to_s, Date.current.to_s]).last.week
      pick = Pick.where("team_id = ? and nfl_week = ?", team, week)
      !pick.any?
    end
  end

  def team_status(team)
    pick = Pick.where(team_id: team)
    losses = pick.where(loss: true).count
    if losses == 0
      team_status = "0 losses"
    elsif losses == 1
      team_status = "1 loss"
    else
      team_status = "out"
    end
    return team_status
  end
end
