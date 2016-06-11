###
### Actually that should be named "inside_area"
###
module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Outside < Action
    
    def display_action(party)
      t("shadowlamb.action.outside", location: party.area.display_name)
    end

    def execute_action(party, elapsed)
      if party.leader.is_mob?
        party.destroy_party!
      end
    end

  end
end