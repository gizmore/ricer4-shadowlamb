module Ricer4::Plugins::Shadowlamb
  class View < Core::Command

    is_list_trigger "sr.view", :for => true, :per_page => 10
    
    requires_player

    def enabled?
      party.inside_location_provides?(:view)
    end
    
    def all_visible_relation
      party.location.sl5_get_shop_items(player)
    end
    
    def search_class_name
      t(:shop_item)
    end
    
  end
end
