module Ricer4::Plugins::Shadowlamb::Core
  class Ai::Plugin
    
    arm_events

    include Include::Base
    include Include::Dice
    include Include::Translates
    
    def player=(player)
      @player = player
    end
    
    def player
      @player
    end
    
    def init(options={})
      
    end

    # def initialize(player)
      # @ai = player.instance_variable_get(:@sl5_AI)
      # @player = player # humans can purchase plugins?
      # @goals = @ai.goals
    # end
#     
    # def sl5_ai_plugin_init(ai_plugin, options={})
      # @options = options
    # end
    
  end
end
