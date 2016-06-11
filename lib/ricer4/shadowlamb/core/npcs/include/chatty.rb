module Ricer4::Plugins::Shadowlamb::Core
  module Ai::Chatty
    
    EMPTY_ARGS = {}
    
    def chat_replied?
      @chatter_replied
    end
    
    def before_chat(speaker, plugin, word, text)
      @chatter_said = word
      @chatter_answered = text
      @chatter_reply = nil
      @chatter_plugin = plugin
      @chatter_speaker = speaker
      @chatter_pointer = 0
      @chatter_replied = false
      @chatter_stacked ||= []
    end
    
    def after_chat
      # @chatter_reply ||= default_chatter_reply
      # @chatter_plugin.reply @chatter_reply
      @chatter_reply = nil
      @chatter_replied = false
      @chatter_plugin = nil
      @chatter_speaker = nil
      @chatter_said = nil
      @chatter_answered = nil
    end
    
    def default_chatter_reply
      t('shadowlamb.npcs.default_reply')
    end
    
    def chat_about(word, args=EMPTY_ARGS, &block)
      return if @chatter_replied
      if @chatter_pointer <= @chatter_stacked.length
        if @chatter_said.name.to_sym == word 
          chat_about_reply(word, args, @chatter_pointer)
        end
      elsif @chatter_stacked[@chatter_pointer] == word.to_sym
        @chatter_pointer += 1
        block.call(@chatter_speaker, self, word)
        @chatter_pointer -= 1
      end
    end
    
    def chat_about_reply(word, args, level)
      @chatter_replied = true
      @chatter_stacked = @chatter_stacked[0..level-1]
      @chatter_stacked[level] = word
      chat_rply(word, args)
      teach_new_word(@chatter_speaker, @chatter_said)
    end
    
    def chat_rply(key, args=EMPTY_ARGS)
      chat_reply(t(key, args))
    end
    
    def chat_reply(text)
      @chatter_replied = true
      @chatter_plugin.reply(text)
    end
    
    def teach_new_word(speaker, word)
      Ricer4::Plugins::Shadowlamb::Core::Knowledge.teach_player_word(speaker, word)
    end
    
  end
  
  Npc.send(:include, Ai::Chatty)
end
