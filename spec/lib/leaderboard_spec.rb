require 'spec_helper'

RSpec.describe Leaderboard do
  let (:leaderboard) { Leaderboard.new }

  describe ".new" do
    it "stores all of the game data" do
      expect(leaderboard.games[0][:home_team]).to eq("Patriots")
      expect(leaderboard.games[0][:away_team]).to eq("Broncos")
      expect(leaderboard.games[0][:home_score]).to eq(17)
      expect(leaderboard.games[0][:away_score]).to eq(13)
    end

    it "creates an array of team data" do
      expect(leaderboard.team_data).to eq([])
    end
  end

  describe "#create_team_objects" do
    it "stores a list of all the teams names in an array" do
      leaderboard.create_team_objects
      expect(leaderboard.team_array).to eq(["Patriots", "Broncos", "Colts", "Steelers"])
    end

    it "uses the stored teams to generate new team objects and store them in the team_data variable" do
      leaderboard.create_team_objects
      expect(leaderboard.team_data[0].name).to eq("Patriots")
      expect(leaderboard.team_data[0].rank).to eq(nil)
      expect(leaderboard.team_data[0].wins).to eq(0)
      expect(leaderboard.team_data[0].losses).to eq(0)
    end
  end

  describe "#victor" do
    it "determines what team won and increases their number of wins or losses" do
      leaderboard.create_team_objects
      leaderboard.victor
      expect(leaderboard.team_data[0].name).to eq("Patriots")
      expect(leaderboard.team_data[0].wins).to eq(3)
      expect(leaderboard.team_data[1].name).to eq("Broncos")
      expect(leaderboard.team_data[1].wins).to eq(1)
    end
  end

  describe "#rank_teams" do
    it "calculates a teams winning percentage" do
      leaderboard.create_team_objects
      leaderboard.victor
      leaderboard.rank_teams
      expect(leaderboard.team_rankings_sorted[0][0]).to eq("Patriots")
      expect(leaderboard.team_rankings_sorted[0][1]).to eq(1.0)
    end

    it "assigns the teams rank" do
      leaderboard.create_team_objects
      leaderboard.victor
      leaderboard.rank_teams
      expect(leaderboard.team_data[0].name).to eq("Patriots")
      expect(leaderboard.team_data[0].rank).to eq(1)
    end
  end

  describe "#display" do
    it "creates a header array for the leaderboard" do
      leaderboard.create_team_objects
      leaderboard.victor
      leaderboard.rank_teams
      leaderboard.display

      expect(leaderboard.header).to eq(["Name", "Rank", "Wins", "Losses"])
    end

    it "builds an array that includes all the teams, their rank, wins, and losses" do
      leaderboard.create_team_objects
      leaderboard.victor
      leaderboard.rank_teams
      leaderboard.display

      expect(leaderboard.leaderboard_display[0][0]).to eq("Patriots")
      expect(leaderboard.leaderboard_display[0][1]).to eq(1)
      expect(leaderboard.leaderboard_display[0][2]).to eq(3)
      expect(leaderboard.leaderboard_display[0][3]).to eq(0)
    end

    it "prints out the leaderboard to the terminal" do
      leaderboard.create_team_objects
      leaderboard.victor
      leaderboard.rank_teams
      leaderboard.display

      expect { leaderboard.display }.to output.to_stdout
    end
  end

end
