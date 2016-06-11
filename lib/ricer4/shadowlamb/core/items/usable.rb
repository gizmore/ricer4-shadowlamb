load File.expand_path("../item.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Usable < Item
  
    ######################
    ### Override these ###
    ######################
    def use_on_self()
      user_on_player(owner)
    end

    def use_on_player(target)
    end
    
    def use_on_friend(target)
      raise Ricer4::ExecutionException.new(t(:err_cannot_use_on_friends))
    end
    
    def use_on_enemy(target)
      raise Ricer4::ExecutionException.new(t(:err_cannot_use_on_enemies))
    end

    def use_on_item(target)
      raise Ricer4::ExecutionException.new(t(:err_cannot_use_on_items))
    end

    def use_on_location(target)
      raise Ricer4::ExecutionException.new(t(:err_cannot_use_on_locations))
    end

    def use_on_obstacles(obstacle)
      unless obstacle.sl5_on_being_used(owner, self)
        raise Ricer4::ExecutionException.new(t(:err_item_recipe_use, item1: self.display_name, item2: obstacle.display_name))
      end
    end
      
  end
end
