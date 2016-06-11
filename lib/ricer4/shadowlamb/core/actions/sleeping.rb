module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Sleeping < Action
    
    def display_action(party)
      t("shadowlamb.action.sleeping", location: party.location.display_name)
    end

    def execute_action(party, elapsed)
      unless party_sleepy?(party)
        get_plugin('Shadowlamb/Wakeup').execute_wakeup(party)
      end
    end
    
    def party_sleepy?(party)
      party.members.each do |member|
        return true if player_sleepy?(member)
      end
      false
    end
    
    def player_sleepy?(player)
      (player.hp < player.max_hp) ||
      (player.mp < player.max_mp) ||
      (player.get_feeling(:tired) > 4000)
    end

  end
end
