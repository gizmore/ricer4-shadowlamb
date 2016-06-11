module Ricer4::Plugins::Shadowlamb
  class World::Peine::Kalle < Core::StationaryNpc
    
    stationary_npc_inside 'Peine::Flat::Etage2'
    
    has_ai script: 'chatter' do |speaker, listener, word|
      listener.chat_about(:gizmore)
      listener.chat_about(:hirsch)
      listener.chat_about(:peter)
      listener.chat_about(:mathew)
    end
    
    include World::Peine::NaiveCitizen

    has_ai script: 'questie', quest: 'Peine::Peninsula'
    
  end
  
end
