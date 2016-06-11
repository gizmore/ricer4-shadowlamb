module ActiveRecord::Magic::Param
  class SlInventoryItem < ShadowlambParam
    
    def default_options
      super.merge(:multiple => true)
    end
    
    def input_to_value(input)
      items = own_player.inventory
      parse_item_param(input, items)
    end
  end
end
