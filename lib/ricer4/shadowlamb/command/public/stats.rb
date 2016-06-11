module Ricer4::Plugins::Shadowlamb
  class Stats < Core::Command
    
    trigger_is :stats

    #requires_player false # Explicit no player
      
    has_usage '', function: :execute_stats
    
    def execute_stats
      rply :msg_stats,
        parties: player_factory.parties.count,
        players: player_factory.players.count,
        humans: player_factory.humans.count,
        npcs: player_factory.npcs.count,
        mobs: player_factory.mobs.count,
        realnpc: player_factory.realnpc.count,
        stationary: player_factory.stationary.count
    end
      
  end
end
