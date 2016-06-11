module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Inside < Action
    
    def display_action(party)
      t("shadowlamb.action.inside", location: party.location.display_name, coordinates: party.location.coordinates.display_name)
    end

    def execute_action(party, elapsed)
    end
    
    
  end
end
