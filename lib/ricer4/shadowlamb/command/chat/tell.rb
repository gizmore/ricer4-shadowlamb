module Ricer4::Plugins::Shadowlamb
  class Tell < Core::Command
    
    trigger_is :tell
    
    requires_player

    has_usage '<sl_near_player> <sl_known_word>'
    has_usage '<sl_near_player> <sl_known_word> <message>'
    def execute(listener, word, text=nil)
      listener.before_chat(self.player, self, word, text)
      listener.call_hook(:sl5_on_tell, self.player, listener, word, text)
      listener.after_chat
    end
      
  end
end
