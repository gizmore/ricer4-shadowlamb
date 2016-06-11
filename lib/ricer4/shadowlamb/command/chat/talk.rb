module Ricer4::Plugins::Shadowlamb
  class Talk < Core::Command
    
    trigger_is :talk
    
    requires_player

    has_usage '<sl_near_stationary> <sl_known_word>'
    def execute(player, word)
      get_plugin('Shadowlamb/Tell').execute(player, word)
    end
      
  end
end
