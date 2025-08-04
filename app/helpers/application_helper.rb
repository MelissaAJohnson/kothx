module ApplicationHelper
  def set_current_week
    if !NflWeek.first.has_started?
      return 1
    else
      NflWeek.where(["start_date <= ? and end_date >= ?", Date.current.to_s, Date.current.to_s]).last.week
    end
  end

  def deadline # sets deadline to Sun - in UTC - of current week
      current_week_end = NflWeek.where(["start_date <= ? and end_date >= ?", Date.current.to_s, Date.current.to_s]).last.end_date
      deadline = (current_week_end - 1) + 5.hours # added 5 hours because time comes across in UTC. +5 makes it US Central time
      return deadline
  end
end
