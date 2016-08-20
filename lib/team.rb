class Team
  attr_reader :name
  attr_accessor :wins, :rank, :losses

  def initialize(name)
    @name = name
    @rank = nil
    @wins = 0
    @losses = 0
  end
end
