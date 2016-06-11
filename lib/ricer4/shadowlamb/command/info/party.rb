module Ricer4::Plugins::Shadowlamb
  class Party < Core::Command
    
    trigger_is :party
    
    requires_player
    
    has_usage  '<sl_value>', function: :execute_show_party_values
    def execute_show_party_values(value_name)
      
    end
    

    has_usage  '', function: :_execute_show_party_status
    def _execute_show_party_status
      execute_show_party_status(player)
    end
    def execute_show_party_status(player)
      if player.is_alone?
        reply t(:msg_party_alone, action: party.display_action) + player.busy_text
      elsif player.is_leader?
        reply t(:msg_party_lead, members: party.display_members, action: party.display_action) + player.busy_text
      else
        reply t(:msg_party_member, members: party.display_members, action: party.display_action) + player.busy_text
      end
    end
      
  end
end
