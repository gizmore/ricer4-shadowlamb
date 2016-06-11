load File.expand_path("../usable.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Openable < Usable
  
    ######################
    ### Override these ###
    ######################
    def open
    end
    
    def use_on_self()
      open
    end
      
  end
end
