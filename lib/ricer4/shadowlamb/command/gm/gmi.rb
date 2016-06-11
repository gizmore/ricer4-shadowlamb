module Ricer4::Plugins::Shadowlamb
  class Gmi < Core::Command
    
    trigger_is :gmi
    
    permission_is :responsible
      
    has_usage  '<sl_player> <sl_item_name>', function: :execute_create_item
    
    def execute_create_item(player, item)
      if player.user_id != sender.id
        rply :msg_gmi_rply, item: item.display_name, user: player.display_name
      end
      player.localize!.send_message(t(:msg_gmi_from, item: item.display_name, gm: sender.display_name))
      player.give_item(item)
    end
      
  end
end
