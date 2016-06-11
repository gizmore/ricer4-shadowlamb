module ActiveRecord::Magic::Param
  class SlStoreItem < ShadowlambParam
    
    def default_options
      super.merge(:multiple => true)
    end
    
    def input_to_value(input)
      items = own_party.location.sl5_get_shop_items(own_player)
      parse_item_param(input, items)
    end
    
  end
end
