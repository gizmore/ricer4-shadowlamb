module Ricer4::Plugins::Shadowlamb
  module World::Peine::NaiveCitizen
    
    def self.included(base)
      base.has_ai script: 'chatter' do |speaker, listener, word|
        listener.chat_about(:hello) do
          listener.chat_about(:yes)
          listener.chat_about(:no)
        end
      end
    end
    
  end
end
