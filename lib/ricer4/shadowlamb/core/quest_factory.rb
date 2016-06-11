module Ricer4::Plugins::Shadowlamb::Core
  class QuestFactory
    
    def self.instance; @instance ||= self.new; end
    
    include Include::Base

    def get_quest(quest_name)
      Ricer4::Plugins::Shadowlamb::Core::Quest.by_name(quest_name)
    end
    
    def get_or_create_mission(quest, player)
      Ricer4::Plugins::Shadowlamb::Core::Mission.find_or_create_by(:quest_id => quest.id, :player_id => player.id)
    end
    
    def get_mission(player, quest_name)
      quest = get_quest(quest_name)
      mission = get_or_create_mission(quest, player)
    end
    
  end
end
