module Ricer4::Plugins::Shadowlamb
  class World::Peine::Peter < Core::StationaryNpc
    
    stationary_npc_inside 'Peine::Flat::Etage2'

    has_ai script: 'chatter' do |speaker, listener, word|
      byebug
      chat_about(:renraku, count: self.human_count) do 
        chat_about(:shadowrun, count: self.runner_count) do 
          chat_about(:dangerous, count: self.dolt_count)
        end
      end
    end

    def human_count; Ricer4::Plugins::Shadowlamb::Core::Player.human.count; end
    def runner_count; Ricer4::Plugins::Shadowlamb::Core::Player.runner.count; end
    
    def sl5_on_tell(player, message)
    end
    
    def dolt_count
      4
    end
    
  end
end
