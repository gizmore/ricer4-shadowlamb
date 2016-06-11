module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Move < Action
    
    def display_action(party)
      t("shadowlamb.action.move", coordinates: party.target_object.display_name, area: party.area.display_name)
    end

    def target_id(party, coordinate)
      raise Ricer4::ExecutionException.new(t(:err_cannot_walk_that_far)) unless coordinate.valid?
      # new_area = shadowverse.locate_area(coordinate)
      # raise Ricer4::ExecutionException.new(t(:err_cannot_walk_that_far)) unless new_area.reachable_by?(party)
      coordinate.to_string
    end

    def target_object(party)
      Coordinate.parse!(party.target)
    end

    def execute_action(party, elapsed)
      move_party(party, elapsed)
    end

    def party_reaches_coordinates(party)
      action = party.location ? :knocking : :outside
      party.push_action(action)
    end
    
    ################
    ### Velocity ###
    ################
    def get_party_velocity(party)
      get_party_kmh(party) / 3.6
    end
    
    def get_party_kmh(party)
      7.2
    end
    
    ###
    ###
    ### 
    ### Move party on google map...
    ### Detect area and location changes and fire events for changes
    ###
    def move_party(party, elapsed)
      
      bot.log.debug("Move#move_party #{party.display_debug} for #{elapsed} seconds.")
      
      party_caught = false

      # Velocity      
      meters_second = get_party_velocity(party)
      meters_walked = meters_second * elapsed
      bot.log.debug("Velocity is #{meters_second} m/s and they walked #{meters_walked} meters.")
      
      # Calc vector
      old_lat, old_lon = party.lat, party.lon
      aim_lat, aim_lon = party.target_object.lat, party.target_object.lon
      vec_lat, vec_lon = aim_lat - old_lat, aim_lon - old_lon

      # Calc distance      
      old_dist = party.distance_to_point(aim_lat, aim_lon)
      new_dist = old_dist - meters_walked
      old_sign = old_dist > 0 ? 1 : -1
      new_sign = new_dist > 0 ? 1 : -1
      moved_by = old_dist == 0 ? 0 : 1.0 - (new_dist/old_dist)
      bot.log.debug("Distance reduced from #{old_dist} to #{new_dist}. This was #{moved_by} percent.")
      
      # Calc new coords
      if old_sign != new_sign
        new_lat, new_lon = aim_lat, aim_lon
      else
        new_lat, new_lon = moved_by*vec_lat+old_lat, moved_by*vec_lon+old_lon
      end
      party.set_lat_lon(new_lat, new_lon)
      
      # Trigger location change events
      begin
        party.moved
      rescue => e
        party.set_lat_lon(old_lat, old_lon)
        party.stop!
      end
      # arm_signal(party_area, 'party/moved', party)

      # Target coords reached
      if (old_dist == 0) || (new_sign != old_sign)
        party_reaches_coordinates(party)
      else
        arm_signal(party.area, 'party/moving', party)
      end
    end
    
    # Fix invalid position outside of areas
    arm_subscribe('party/loaded') do |sender, party|
      if party.area.is_world?
        location = shadowverse.respawn_location(party)
        location.top_area(party).clamp_party(party)
      end
    end
    
  end
end
