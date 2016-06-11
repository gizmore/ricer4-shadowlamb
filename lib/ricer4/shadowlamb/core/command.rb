module Ricer4::Plugins::Shadowlamb::Core
  class Command < Ricer4::Plugin
    
    include Include::Base
    include Include::HasRequirements
    
#    def before_execution; shadowverse.lock; end
#    def after_execution;  shadowverse.unlock; end

    def plugin_enabled?; true; end
    
    protected
    
    def player
      sender.instance_variable_defined?(:@sl5_player) ? 
        sender.instance_variable_get(:@sl5_player) :
        load_player 
    end
    
    def party
      player.party
    end
    
    private
    
    def load_player
      player_factory.load_human(sender)
    end

  end

  Command.extend Extend::RequiresLeadership
  Command.extend Extend::RequiresPlayer
  Command.extend Extend::WorksWhenAlone
  Command.extend Extend::WorksWhenIdle
  Command.extend Extend::WorksWhen
  Command.extend Ricer4::Extend::IsCombatTrigger

end
