module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Fighting < Actions::Talking
    
    def display_action(party)
      t("shadowlamb.action.fighting", enemies: party.other_party.display_combat_members)
    end
    
    arm_subscribe('party/started/fighting') do |sender, party|
      party.send_message("shadowlamb.msg_encounter", enemies: party.enemy_party.display_combat_members)
    end
    
    def execute_action(party, elapsed)
      bot.log.debug("Actions::Fighting#execute_action() for #{party.display_members} - elapsed: #{elapsed.to_i}")
      party.members.each do |member|
        member.busy(-elapsed)
      end
    end
    
  end
end
