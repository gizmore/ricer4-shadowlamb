module Ricer4::Plugins::Shadowlamb
  class Buy < Core::Command

    trigger_is "sr.buy"
    
    requires_player

    def enabled?
      party.inside_location_provides?(:buy)
    end

    has_usage '<sl_store_item>'
    def execute(items)
      byebug
      items.each{|item|item.amount = item.selected_amount}
      total = items.sum{|item|item_buy_price(item)}
      return rply :err_low_money if player.get_base(:nuyen) < total
      player.give_items(items)
    end
    
    def item_buy_price(item)
      item.instance_variable_get(:@sl5_buy_price) * item.amount * discount_for(player)
    end
    
    def discount_for(player)
      (1.0 - player.get_adjusted_percent(:negotiation) * player.party.location.sl5_shop_max_discount).clamp(0.0, 1.0)
    end
    
  end
end
