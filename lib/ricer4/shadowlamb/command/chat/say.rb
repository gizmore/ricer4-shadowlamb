module Ricer4::Plugins::Shadowlamb
  class Say < Core::Command
    
    trigger_is :say
    
    requires_player

    has_usage  '<sl_known_word>', function: :execute_say
    def execute_say(word)
      # All who can hear it
      shadowverse.players_in_range(party).each do |player|
        player.sl5_on_say(player, message)
      end
      # Sesame open
      player.location.sl5_on_say(player, message)
    end
      
  end
end
