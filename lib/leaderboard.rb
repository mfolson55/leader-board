require_relative "../spec/spec_helper"

class Leaderboard
  attr_reader :games, :team_data, :wins, :team_rankings_sorted, :leaderboard_display, :header, :team_array

GAME_INFO = [
    {
      home_team: "Patriots",
      away_team: "Broncos",
      home_score: 17,
      away_score: 13
    },
    {
      home_team: "Broncos",
      away_team: "Colts",
      home_score: 24,
      away_score: 7
    },
    {
      home_team: "Patriots",
      away_team: "Colts",
      home_score: 21,
      away_score: 17
    },
    {
      home_team: "Broncos",
      away_team: "Steelers",
      home_score: 11,
      away_score: 27
    },
    {
      home_team: "Steelers",
      away_team: "Patriots",
      home_score: 24,
      away_score: 31
    }
]


  def initialize
    @games = GAME_INFO
    @team_data = []
  end

  def create_team_objects
    @team_array = []
    @games.each do |game|
      if !@team_array.include?(game[:home_team])
        @team_array << game[:home_team]
      elsif !@team_array.include?(game[:away_team])
        @team_array << game[:away_team]
      end
    end
    @team_array.each do |team|
      @team_data << Team.new(team)
    end
  end

  def victor
    @games.each do |game|
      if game[:home_score] > game[:away_score]
        @team_data.each do |team|
          if team.name == game[:home_team]
            team.wins += 1
          elsif team.name == game[:away_team]
            team.losses += 1
          end
        end
      else
        @team_data.each do |team|
          if team.name == game[:away_team]
            team.wins += 1
          elsif team.name == game[:home_team]
            team.losses += 1
          end
        end
      end
    end
  end

  def rank_teams
    team_rankings = {}
    @team_rankings_sorted = []
    @team_data.each do |team|
      total_games = team.wins + team.losses
      if team.wins == 0
        win_percentage = 0.0
      else
        win_percentage = team.wins.to_f / total_games
      end
      team_rankings[team.name] = win_percentage
    end
    @team_rankings_sorted = team_rankings.sort_by {|key, value| value}.reverse
    @team_data.each do |team|
      counter = 0
      @team_rankings_sorted.each do
        if team.name == @team_rankings_sorted[counter][0]
          team.rank = @team_rankings_sorted.index(team_rankings_sorted[counter]) + 1
        end
        counter += 1
      end
    end
  end

  def display
    def build_display(rows, columns)
      @header = ["Name", "Rank", "Wins", "Losses"]
      display = []
      rows.times do
        row = []
        columns.times do
          row << nil
        end
        display << row
      end
      display
    end

    @leaderboard_display = build_display((@team_data.size), 4)

    counter = 0
    while counter <= @team_data.length - 1
      @leaderboard_display[counter][0] = @team_data[counter].name
      @leaderboard_display[counter][1] = @team_data[counter].rank
      @leaderboard_display[counter][2] = @team_data[counter].wins
      @leaderboard_display[counter][3] = @team_data[counter].losses
      counter += 1
    end
    puts "-------------------------------------"
    puts "| #{header[0]}".ljust(13) + " #{header[1]}".ljust(8) + " #{header[2]}".ljust(8) + " #{header[3]} |"
    @team_data.each do |team|
      puts "| #{team.name}".ljust(15) + "#{team.rank}".ljust(8) + " #{team.wins}".ljust(8) + " #{team.losses}    |"
    end
    puts "-------------------------------------"
  end
end

leaderboard = Leaderboard.new
leaderboard.create_team_objects
leaderboard.victor
leaderboard.rank_teams
leaderboard.display
