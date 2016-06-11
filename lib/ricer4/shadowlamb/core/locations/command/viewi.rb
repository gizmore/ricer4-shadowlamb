module Ricer4::Plugins::Shadowlamb
  class Viewi < Core::Command

    include Ricer4::Plugins::Shadowlamb::Core::Include::ParseParamRelation

    is_search_trigger "sr.viewi", :for => true, :per_page => 10
    
    requires_player

    def enabled?
      party.inside_location_provides?(:viewi)
    end
    
    def all_visible_relation
      party.location.sl5_get_shop_items(player)
    end
    
    def search_class_name
      t(:shop_item)
    end
    
    def search_relation(relation, input)
      Array(parse_param_relations(relation, input))
    end
    
  end
end
