require File.expand_path("../beam_into.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core
  class Actions::BeamTo < Actions::BeamInto
    
    def display_action(party)
      t("shadowlamb.action.beam_to", location: party.target_object.display_name)
    end

    def execute_action(party, elapsed)
      execute_beaming(party, elapsed)
      party.push_action(:knocking)
    end

  end
end
