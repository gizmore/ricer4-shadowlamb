###
### Party is outside a location.
###
module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Parking < Action
    
    # Fix invalid parking state
    arm_subscribe('party/loaded') do |sender, party|
      if party.action.is_a?(self)
        if !party.location
          party.push_action(:outside)
        end
      end
    end

    def display_action(party)
      t("shadowlamb.action.parking", location: party.location.display_name, info: party.location.displayinfo)
    end

    def execute_action(party, elapsed)
    end

  end
end
