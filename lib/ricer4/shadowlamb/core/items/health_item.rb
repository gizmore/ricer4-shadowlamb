load File.expand_path("../usable.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class HealthItem < Usable
  
    def use_on_friend(target)
      use_on_player(target)
    end
     
    def use_on_player(target)
      byebug
    end
    
  end
end
