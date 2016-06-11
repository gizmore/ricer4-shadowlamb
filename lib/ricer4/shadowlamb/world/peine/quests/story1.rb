module Ricer4::Plugins::Shadowlamb::World
  module Peine
    class Story1 < Ricer4::Plugins::Shadowlamb::Core::Quest
      
      is_quest
      
      arm_subscribe('player/created') do |sender, player|
        quest_factory.get_mission(player, "Peine/Story1").accept
      end
      
      def sl5_init_quest
        arm_subscribe('mission/accept', self) do |sender, player, mission|
          player.send_message(t(:story1))
          player.send_message(t(:story2))
          player.send_message(t(:story3))
        end
        arm_subscribe('mission/accepted', self) do |sender, player, mission|
          player.send_message(t(:story4))
        end
      end
    
    end
  end
end