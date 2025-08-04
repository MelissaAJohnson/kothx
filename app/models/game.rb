class Game < ApplicationRecord
  def import(game)
    self.year = game.year
    self.week = game.week
    self.season = game.season
    self.home = game.home
    self.away = game.away
    self.status = game.status
    self.scheduled_time = game.scheduled
    self.save!
  end

  def score_import(summary) # this is called from score_import.rake task
    self.home_score = summary.home_team.points
    self.away_score = summary.away_team.points
    self.winner = calculate_winner(summary)
    self.save!
  end

  def calculate_winner(game)
    # if game.home_team.points > summary.away_team.points --> this used when pulling scores from API
    if game.home_score? # A score must exist before we check for the largest
      if game.home_score > game.away_score
        self.winner = game.home
      elsif game.home_score < game.away_score
        self.winner = game.away
      else
        self.winner = ''
      end
    end
  end
end
