###
### Trying to enter a location.
### Changes state to inside or parking.
###
module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Knocking < Action
    
    # Fix invalid knocking state
    arm_subscribe('party/loaded') do |sender, party|
      if party.action.is_a?(self)
        if !party.location
          party.push_action(:outside)
        end
      end
    end

    def display_action(party)
      t("shadowlamb.action.knocking", location: party.location.display_name, info: party.location.displayinfo)
    end

    def execute_action(party, elapsed)
      if party.was?(:goto, :parking)
        try_to_enter(party)
      else
        stay_outside(party)
      end
    end
    
    def try_to_enter(party)
      location = party.location
      if (location.sl5_can_enter_location?(party, location))
        enter_location(party)
      else
        cannot_enter(party)
      end
    end
    
    def enter_location(party)
      location = party.location
      party.push_action(:inside)
      arm_signal(location, 'party/enters/location', party, location)
    end
    
    def cannot_enter(party)
      stay_outside(party)
    end
    
    def stay_outside(party)
      location = party.location
      party.push_action(:parking)
      arm_signal(location, 'party/outside/location', party, location)
    end


  end
end
