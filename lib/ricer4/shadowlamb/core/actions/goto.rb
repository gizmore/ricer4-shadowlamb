module Ricer4::Plugins::Shadowlamb::Core
  class Actions::Goto < Actions::Move
    
    def target_id(party, location)
      raise Ricer4::ExecutionException.new(t(:err_not_reachable, target: location.display_name)) unless location.reachable_by?(party)
      location.coordinates.to_string
    end

    def display_action(party)
      t("shadowlamb.action.goto", location: party.target_object.display_name)
    end

  end
end
