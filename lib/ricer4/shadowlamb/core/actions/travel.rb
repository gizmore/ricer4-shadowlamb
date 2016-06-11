module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Travel < Actions::Move
    
    def target_id(party, target)
    end

    def execute_action(party, elapsed)
    end
    
    def display_action(party)
      t("action.travel", area: party.target_object.area.display_name)
    end

  end
end
