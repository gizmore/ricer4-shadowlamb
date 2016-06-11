module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Explore < Actions::Move
    
    # def target_id(party, target=nil)
      # party.area.random_coordinates_string
    # end

    def display_action(party)
      t("shadowlamb.action.explore", area: party.area.display_name)
    end
    
    def party_reaches_coordinates(party)
      action = party.location ? :knocking : :outside
      party.push_action(action)
    end
    

  end
end
