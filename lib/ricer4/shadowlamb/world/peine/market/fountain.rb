module Ricer4::Plugins::Shadowlamb
  class World::Peine::Fountain < Core::Obstacle
    
    is_obstacle_at 52.323347, 10.225731
    
    def sl5_on_being_used(player, object)
      return fillup_water_bottle(player, object) if object.is_a?(Core::Items::EmptyBottle)
      false
    end
    
    def fillup_water_bottle(player, object)
      true
    end

  end
end
