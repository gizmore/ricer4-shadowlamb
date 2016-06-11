module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Spawning < Action
    
    def execute_action(party, elapsed)
      if party.leader.is_mob?
        party.destroy_party!
      else
        location = shadowverse.respawn_location(party)
        party.push_action(:beam_into, location)
        party.send_message(:msg_respawned) do
          {location: location.display_name}
        end
      end
    end

  end
end
