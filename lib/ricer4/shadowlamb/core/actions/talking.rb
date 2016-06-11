module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Talking < Action
    
    def target_id(party, target)
      target.persisted? ? target.id : "##{target.object_id}"
    end

    def target_object(party)
      tid = party.target
      if tid[0] == '#'
        player_factory.party_by_object_id(tid[1..-1].to_i)
      else
        player_factory.party_by_id(tid)
      end
    end

    def display_action(party)
      t("action.talking", to: party.other_party.display_combat_members)
    end
    
    def execute_action(party, elapsed)
      puts "TALKING!!!"
    end
    
  end
end
