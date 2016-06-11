require File.expand_path("../move.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class Actions::BeamInto < Actions::Move
    
    def display_action(party)
      t("shadowlamb.action.beam_into", location: party.target_object.display_name)
    end

    def target_id(party, target)
      target.id
    end

    def target_object(party)
      shadowverse.location_by_id(party.target.to_i)
    end
    
    def execute_beaming(party, elapsed)
      old_location, new_location = party.location, target_object(party)
      old_area, new_area = party.area, new_location.area
      if old_location != new_location
        party.set_lat_lon(new_location.lat, new_location.lon)
        party.location, party.area, party.floor = new_location, new_location.area, new_location.floor
        party.party_changes_area(party, old_area, new_area) if old_area != new_area
        party.party_changes_location(party, old_location, new_location)
      end
    end

    def execute_action(party, elapsed)
      execute_beaming(party, elapsed)
      party.push_action(:inside)
    end
    
  end
end
