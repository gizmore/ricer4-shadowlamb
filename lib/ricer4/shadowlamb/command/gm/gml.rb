module Ricer4::Plugins::Shadowlamb
  class Gml < Core::Command
    
    trigger_is :gml
    
    permission_is :responsible
      
    has_usage  '<sl_player> <sl_location>', function: :execute_beam_player
    has_usage  '<sl_player> <sl_location> <boolean>', function: :execute_beam_player
    def execute_beam_player(player, location, inside=false)
      execute_beam_party(player.party, location, inside)
    end
      
    def execute_beam_party(party, location, inside)
      party.interrupt!
      party.push_action((inside ? :beam_into : :beam_to), location)
      msgkey = inside ? :msg_gml_beamed_inside : :msg_gml_beamed_outside
      party.send_message(msgkey,
        gm: gm_name(sender),
        location: location.display_name
      )
      msgkey = inside ? :msg_beamed_inside : :msg_beamed_outside
      rply msgkey, members: party.display_members, location: location.display_name
    end
    
  end
end
