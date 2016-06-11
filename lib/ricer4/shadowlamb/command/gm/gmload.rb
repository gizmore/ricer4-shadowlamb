module Ricer4::Plugins::Shadowlamb
  class Gmload < Core::Command
    
    trigger_is :gmload
    permission_is :responsible
      
    has_usage  '<sl_player>', function: :execute_gmload
    def execute_gmload(player)
    
    end
      
  end
end
