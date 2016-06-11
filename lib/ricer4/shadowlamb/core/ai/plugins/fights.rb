module Ricer4::Plugins::Shadowlamb::Core
  class Ai::Fights < Ai::Plugin

    def sl5_ai_plugin_init(ai_plugin, options={})
      super
      @aggressive = rand(0, 100)
    end
    
  end
end
