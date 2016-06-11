module Ricer4::Plugins::Shadowlamb::Core
  class Ai::Chatter < Ai::Plugin
    
    def init(options={})
      if options[:story]
        options[:proc] = Proc.new do 
          Object.const_get("Ricer4::Plugins::Shadowlamb::World::#{options[:story]}").sl5_on_tell($1, $2, $3)
        end
      end
      arm_subscribe(:sl5_on_tell, player) do
        options[:proc].call
      end
    end
    
  end
end
