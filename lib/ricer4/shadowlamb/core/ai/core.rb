module Ricer4::Plugins::Shadowlamb::Core
  class Ai::Core
    
    def initialize(player)
      @player = player # humans can purchase plugins?
      @player.instance_variable_set(:@sl5_AI, self)
      @plugins = []
      @goals = Goals.new
    end
    
    def add_plugin(ai_plugin_name, options={})
      @plugins.push(create_plugin(ai_plugin_name, options))
    end
    
    def create_plugin(ai_plugin_name, options={})
      klass = Ai::Plugins.const_get(ai_plugin_name.camelize)
      plugin = klass.new(@player)
      plugin.sl5_on_init_plugin(plugin, options)
      plugin
    end
    
  end
end
