load File.expand_path("../usable.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Consumable < Usable
  
    ######################
    ### Override these ###
    ######################
    def consume
    end
    
    def use_on_self()
      consume
    end
      
  end
end
