class Pick < ApplicationRecord
  audited
  belongs_to :team
  validates :nfl_team, presence: true
  validates :nfl_week, presence: true
  validates :team_id, presence: true

  after_create :associate_pick_game
  # after_create :send_pick_email

  def self.to_csv
    @teams = Team.all
    attributes = %w{team_id nfl_week nfl_team}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      @teams.order(:name).each do |team|
        team.picks.order(:nfl_week).each do |pick|
          csv << [team.name, pick.nfl_week, pick.nfl_team]
          #csv << pick.attributes.values_at(*attributes)
        end
      end
    end
  end

  private

  def send_pick_email
    PickMailer.new_pick(self.team, self).deliver_now
  end

  def associate_pick_game
    weeks_games = Game.where(week: self.nfl_week)
    game_id = weeks_games.where(["home = ? or away = ?", self.nfl_team, self.nfl_team]).last.id
    self.update_attributes(game_id: game_id)
  end

  def automated_pick
    # available teams = plucked list (from select_for_pick)
    # look for previous week pick (current_week - 1)
    # automated_pick = previous_week_pick.id + 1 from plucked list
  end
end
