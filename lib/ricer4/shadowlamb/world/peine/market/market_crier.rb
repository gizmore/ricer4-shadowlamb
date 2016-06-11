module Ricer4::Plugins::Shadowlamb
  class World::Peine::MarketCrier < Core::Npc
    
    stationary_npc_at 52.323454, 10.225791
    
    def sl5_on_tell(player, message)
      chat_about(:renraku, count: self.human_count) do 
        chat_about(:shadowrun, count: self.runner_count) do 
          chat_about(:dangerous, count: self.dolt_count)
        end
      end
    end

  end
end
